Gandalf.Views.Events ||= {}

class Gandalf.Views.Events.Index extends Backbone.View

  # options has keys [collection, startDate, period]
  initialize: ()->
    _.bindAll(this, 
      "adjustOverlappingEvents",
      "makeCSSAdjustments",
      "orgVisChange", 
      "catVisChange",
      "renderSubscribedOrganizations",
      "renderSubscribedCategories"
    )

    # Class variables
    @startDate = @options.startDate
    @period = @options.period
    @maxOverlaps = 4                  # Maximum allowed event overlaps
    @first = true                     # First time rendering
    @render()

    # Render AJAX info
    Gandalf.currentUser.fetchSubscribedOrganizations().then @renderSubscribedOrganizations
    Gandalf.currentUser.fetchSubscribedCategories().then @renderSubscribedCategories

    # Listening for global events
    Gandalf.dispatcher.bind("eventVisibility:change", @hideHidden, this)
    Gandalf.dispatcher.bind("window:resize", @resetEventPositions, this)
    Gandalf.dispatcher.on("event:click", @eventClick, this)

  template: JST["backbone/templates/events/index"]
  popoverTemplate: JST["backbone/templates/calendar/calendar_popover"]

  el: "#content"

  events:
    "scroll" : "scrolling"

  # Rendering functions

  renderWeekCalendar: () ->
    console.log @days
    view = new Gandalf.Views.Events.CalendarWeek(
      startDate: moment(@startDate)
      days: @days
    )
    @$("#calendar-container").append(view.el)
    if @first
      @$(".cal-body").animate scrollTop: 550, 300
      @first = false
    @hideHidden()

  renderMonthCalendar: () ->
    view = new Gandalf.Views.Events.CalendarMonth(
      startDate: moment(@startDate)
      days: @days
    )
    @$("#calendar-container").append(view.el)
    @hideHidden()

  renderWeekMultiday: () ->
    evs = @collection.getMultidayEvents()
    for event in evs
      view = new Gandalf.Views.Events.CalendarWeekMultiday(
        { model: event, startDate: moment(@startDate) }
      )
      $(".cal-multiday").append(view.el)

  renderFeed: () ->
    noEvents = "<div class='feed-day-header'>You have no upcoming events</div>"
    @$("#feed-list").append(noEvents) if _.isEmpty(@days)
    @doneEvents = []
    for day, events of @days
      @addFeedDay(day, events)

  addFeedDay: (day, events) ->
    view = new Gandalf.Views.Events.FeedDay(day: day, collection: events,done: @doneEvents)
    @$("#feed-list").append(view.el)

  renderSubscribedOrganizations: ->
    subscriptions = Gandalf.currentUser.get('subscribed_organizations')
    hidden = @collection.getHiddenOrgs()
    for s in subscriptions
      invisible = false
      invisible = true if s.id in hidden
      view = new Gandalf.Views.Organizations.Short(model: s, invisible: invisible)
      $("#subscribed-organizations-list").append(view.el)
  
  renderSubscribedCategories: ->
    subscriptions = Gandalf.currentUser.get('subscribed_categories')
    hidden = @collection.getHiddenCats()
    for s in subscriptions
      invisible = false
      invisible = true if s.id in hidden
      view = new Gandalf.Views.Categories.Short(model: s, invisible: invisible)
      $("#subscribed-categories-list").append(view.el)

  renderCalendar: () ->
    if @period == "month"
      @renderMonthCalendar()
      @renderMonthMultiday()
    else 
      @renderWeekCalendar()
      @renderWeekMultiday()
      @adjustOverlappingEvents()

  render: () ->
    $(@el).html(@template({ user: Gandalf.currentUser }))
    split = (@period is "month")
    @collection.splitMultiDay(split)       # Adjust multi-day events
    @days = @collection.group()
    @renderFeed()
    @renderCalendar()
    t = this
    setInterval( ->
      t.resetEventPositions()
    , 20000)
    return this
  
  # Event handlers

  hideHidden: () ->
    orgs = @collection.getHiddenOrgs()
    cats = @collection.getHiddenCats()
    @orgVisChange(orgs)
    @catVisChange(cats)

  scrolling: () ->
    if("#feed-list").scrollTop() + $(".feed").height() == $("#feed-list").height()
      console.log 'go!'

  resetEventPositions: () ->
    $(".cal-week-event").css({ width: "96%" }) # For window resizing
    @makeCSSAdjustments()

  eventClick: (e) ->
    @showPopover(e.model, e.color)

  # Helpers

  orgVisChange: (hiddenOrgs) ->
    $(".js-event").removeClass("event-hidden-org")
    for orgId in hiddenOrgs
      $(".js-event[data-organization-id='#{orgId}']").addClass "event-hidden-org"
    @adjustOverlappingEvents()

  catVisChange: (hiddenCats) ->
    $(".js-event").removeClass("event-hidden-cat")
    for catId in hiddenCats
      id = catId+","
      $(".js-event[data-category-ids*='#{id}']").addClass "event-hidden-cat"
    @adjustOverlappingEvents()

  adjustOverlappingEvents: () ->
    # If an event overlaps with one other, they both get class 'overlap-2', etc. for 3, 4
    # TO DO: if there are more than @maxOverlaps overlaps, create an alert
    # that says not all the events are being shown
    overlaps = @collection.findOverlaps()
    $(".cal-week-event").removeClass("overlap-2 overlap-3 overlap-4 hide")
    for myId, ids of overlaps
      num = ids.length + 1
      num = @maxOverlaps if num > @maxOverlaps
      $(".cal-week-event[data-event-id='#{myId}']").addClass "overlap-#{num}"
      count = 0
      for id in ids
        $(".cal-week-event[data-event-id='#{id}']").addClass "overlap-#{num}"
        count++
    @makeCSSAdjustments()

  # CSS wasn't strong enough for the kind of styling I wanted to do...
  # so we're doing it in JS
  # Cost: 21 * number of events
  makeCSSAdjustments: () ->
    calZ = 10
    for i in [0...7]
      for overlapIndex in [2..@maxOverlaps]
        width = Math.floor(98/overlapIndex)
        selector = ".cal-week-event.overlap-#{overlapIndex}.day-#{i}"
        selector += ":not(.hide, .event-hidden-org, .event-hidden-cat)"
        evs = $(selector)
        $(evs).css({ width: "#{width}%"})
        _.each evs, (e, index) ->
          num = index%overlapIndex
          $(e).css(
            left: "#{width*num}%"
            zIndex: calZ - num
          )

  showPopover: (model, color) ->
    popover = $(".cal-popover")
    placement = "left"
    placement = "right" if moment(model.get("calStart")).day() < 3
    realId = model.get("eventId")
    if model.get("id") isnt realId
      model = @collection.get(realId)
    $(popover)
      .css(placement, "10px")
      .html(@popoverTemplate(e: model, color: color))
      .fadeIn("fast")
    $(".cal-popover .close").click(() ->
      $(this).parents(".cal-popover").fadeOut("fast")
    )
    @makeGMap(model)

  makeGMap: (model) ->
    myPos = new google.maps.LatLng(model.get("lat"), model.get("lon"))
    options = 
      center: myPos
      zoom: 15
      mapTypeId: google.maps.MapTypeId.ROADMAP
    map = new google.maps.Map(document.getElementById("map-canvas"), options)
    marker = new google.maps.Marker(
      position: myPos
      map: map
      title: "Here it is!"
    )
        