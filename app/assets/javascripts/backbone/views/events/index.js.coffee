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
    Gandalf.currentUser.fetchSubscribedOrganizations().then @renderSubscribedOrganizations
    Gandalf.currentUser.fetchSubscribedCategories().then @renderSubscribedCategories
    # Class variables
    @startDate = @options.startDate
    @period = @options.period
    @maxOverlaps = 4
    @first = true # first time rendering
    @second
    @render()
    # Listening for global events
    Gandalf.dispatcher.bind("eventVisibility:change", @hideHidden, this)
    Gandalf.dispatcher.bind("window:resize", @resize, this)

  template: JST["backbone/templates/events/index"]

  el: "#content"

  events:
    "scroll" : "scrolling"

  # Rendering functions

  renderWeekCalendar: () ->
    view = new Gandalf.Views.Events.CalendarWeek(
      startDate: moment(@startDate)
      days: @days
    )
    @$("#calendar-container").append(view.el)
    if @first
      @$("#calendar-container").animate scrollTop: 400, 300
      @first = false
    @hideHidden()

  renderMonthCalendar: () ->
    view = new Gandalf.Views.Events.CalendarMonth(
      startDate: moment(@startDate)
      days: @days
    )
    @$("#calendar-container").append(view.el)
    @hideHidden()

  renderFeed: () ->
    @$("#feed-list").append("<p>You have no upcoming events</p>") if _.isEmpty(@days)
    console.log @days
    for day, events of @days
      @addFeedDay(day, events)

  addFeedDay: (day, events) ->
    view = new Gandalf.Views.Events.FeedDay(day: day, collection: events)
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
    else 
      @renderWeekCalendar()
      @adjustOverlappingEvents()

  render: () ->
    $(@el).html(@template({ user: Gandalf.currentUser }))
    @days = @collection.sortAndGroup()
    @renderFeed()
    @renderCalendar()

    return this
  
  # Event handlers

  hideHidden: () ->
    # $(".cal-week-event").effect("puff")
    orgs = @collection.getHiddenOrgs()
    cats = @collection.getHiddenCats()
    @orgVisChange(orgs)
    @catVisChange(cats)

  scrolling: () ->
    if("#feed-list").scrollTop() + $(".feed").height() == $("#feed-list").height()
      console.log 'go!'

  resize: () ->
    $(".cal-week-event").css({ width: "96%" }) # For window resizing
    @makeCSSAdjustments()

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
    $(".cal-week-event").removeClass("overlap-2 overlap-3 overlap-4")
    for myId, ids of overlaps
      num = ids.length + 1
      $(".cal-week-event[data-event-id='#{myId}']").addClass "overlap-#{num}"
      for id in ids
        $(".cal-week-event[data-event-id='#{id}']").addClass "overlap-#{num}"
    @makeCSSAdjustments()

  # CSS wasn't strong enough for the kind of styling I wanted to do...
  # so we're doing it in JS
  makeCSSAdjustments: () ->
    overlapIndex = 2
    calZ = 10
    while overlapIndex <= @maxOverlaps
      width = Math.floor(98/overlapIndex)
      selector = ".cal-week-event.overlap-#{overlapIndex}"
      selector += ":not(.event-hidden-org, .event-hidden-cat)"
      evs = $(selector)
      $(evs).css({ width: "#{width}%"})
      _.each evs, (e, index) ->
        if index%overlapIndex is 0
          $(e).css(
            left: 0
          )
        else if index%overlapIndex is 1
          $(e).css(
            left: "#{width}%"
            zIndex: calZ - 1
          )
        else if index%overlapIndex is 2
          $(e).css(
            left: "#{width*2}%"
            zIndex: calZ - 2
          )
        else if index%overlapIndex is 3
          $(e).css(
            left: "#{width*3}%"
            zIndex: calZ - 3
          )
      overlapIndex++