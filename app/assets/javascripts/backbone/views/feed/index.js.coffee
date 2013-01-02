Gandalf.Views.Feed ||= {}

class Gandalf.Views.Feed.Index extends Backbone.View

  # options has keys [events, startDate, period]
  initialize: ()->
    _.bindAll(this, 
      "renderSubscribedOrganizations",
      "renderSubscribedCategories"
    )
    @render()

    # Render AJAX info
    Gandalf.currentUser.fetchSubscribedOrganizations().then @renderSubscribedOrganizations
    Gandalf.currentUser.fetchSubscribedCategories().then @renderSubscribedCategories
    Gandalf.dispatcher.on("event:click", @showPopover, this)
    Gandalf.dispatcher.on("popover:hide", @hidePopover, this)

  template: JST["backbone/templates/feed/index"]
  popoverTemplate: JST["backbone/templates/calendar/popover"]

  el: "#content"

  events:
    "click .global-overlay" : "hidePopover"

  # Rendering functions

  renderMenu: (period, startDate) ->
    if period == 'month'
      thisMonth = moment(startDate).day(6).date(1)
      prevMonth = moment(thisMonth).subtract('M', 1).format(Gandalf.displayFormat)
      nextMonth = moment(thisMonth).add('M', 1).format(Gandalf.displayFormat)
      if moment().month() == thisMonth.month()
        weekDate = 'today'
      else
        weekDate = moment(startDate).format(Gandalf.displayFormat)
      # Add to html
      @$(".cal-nav span").html thisMonth.format("MMMM YYYY")
      @$(".cal-nav .previous").attr 'href', '#calendar/' + prevMonth + '/month'
      @$(".cal-nav .next").attr 'href', '#calendar/' + nextMonth + '/month'
      @$(".cal-nav .week").attr 'href', '#calendar/' + weekDate + '/week'
      @$(".cal-nav .month").addClass 'disabled'
    else
      if moment().day(1).format("DD") == moment(startDate).day(1).format("DD")
        month = moment().date(1).format(Gandalf.displayFormat)
      else
        month = moment(startDate).date(1).format(Gandalf.displayFormat)
      prevWeek = moment(startDate).subtract('w', 1).format(Gandalf.displayFormat)
      nextWeek = moment(startDate).add('w', 1).format(Gandalf.displayFormat)
      endDate = moment(startDate).add('d', 6)
      # Add to html
      @$(".cal-nav span").html startDate.format("MMM Do") + " - " + endDate.format("MMM Do") + " " + endDate.format("YYYY")
      @$(".cal-nav .previous").attr 'href', '#calendar/' + prevWeek + '/week'
      @$(".cal-nav .next").attr 'href', '#calendar/' + nextWeek + '/week'
      @$(".cal-nav .week").addClass 'disabled'
      @$(".cal-nav .month").attr 'href', '#calendar/' + month + '/month'
      
  renderFeed: () ->
    noEvents = "<div class='feed-day-header'>You have no upcoming events</div>"
    @$("#body-feed").append(noEvents) if _.isEmpty(@days)
    @doneEvents = []
    for day, events of @days
      @addFeedDay(day, events)

  addFeedDay: (day, events) ->
    view = new Gandalf.Views.Feed.Day(day: day, collection: events, done: @doneEvents)
    @$(".body-feed").append(view.el)

  renderSubscribedOrganizations: ->
    subscriptions = Gandalf.currentUser.get('subscribed_organizations')
    hidden = @options.events.getHiddenOrgs()
    # for s in subscriptions
    #       invisible = false
    #       invisible = true if s.id in hidden
    #       view = new Gandalf.Views.Organizations.Short(model: s, invisible: invisible)
    #       $("#subscribed-organizations-list").append(view.el)
  
  renderSubscribedCategories: ->
    subscriptions = Gandalf.currentUser.get('subscribed_categories')
    hidden = @options.events.getHiddenCats()
    # for s in subscriptions
    #       invisible = false
    #       invisible = true if s.id in hidden
    #       view = new Gandalf.Views.Categories.Short(model: s, invisible: invisible)
    #       $("#subscribed-categories-list").append(view.el)


  render: () ->
    @$el.html(@template({ user: Gandalf.currentUser, startDate: @options.startDate }))
    Gandalf.calendarHeight = $(".content-calendar").height()
    @days = @options.events.group()
    @renderMenu(@options.period, @options.startDate)
    @renderFeed()
    view = new Gandalf.Views.Calendar.Index(
      type: @options.period
      events: @options.events
      startDate: @options.startDate
    )

    $(".content-calendar").append(view.el)
    return this

  showPopover: (object) ->
    model = object.model
    color = object.color
    eId = model.get("eventId")
    if model.get("id") isnt eId
      model = @options.events.get(eId)
    $(".cal-popover").html(@popoverTemplate(e: model, color: color))
    $(".cal-popover,.global-overlay").fadeIn("fast")
    $(".cal-popover .close").click( ->
      Gandalf.dispatcher.trigger("popover:hide")
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

  hidePopover: ->
    $(".cal-popover,.global-overlay").fadeOut("fast")
