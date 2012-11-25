Gandalf.Views.Events ||= {}

class Gandalf.Views.Events.Index extends Backbone.View

  # options has keys [collection, startDate, period]
  initialize: ()->
    _.bindAll(this, "adjustOverlappingEvents")
    Gandalf.currentUser.fetchSubscribedOrganizations().then @renderSubscribedOrganizations
    Gandalf.currentUser.fetchSubscribedCategories().then @renderSubscribedCategories
    # Listening for global events
    Gandalf.dispatcher.bind("index:adjust", @adjustOverlappingEvents)
    # Class variables
    @startDate = @options.startDate
    @period = @options.period
    @maxOverlaps = 4
    @first = true # first time rendering
    @render()

  template: JST["backbone/templates/events/index"]
  calHeaderTemplate: JST["backbone/templates/events/calendar_header"]
  el: "#content"

  events: 
    "click #cal-next" : "next"
    "click #cal-prev" : "prev"
    "click #cal-today" : "today"
    "click #cal-month" : "month"
    "click #cal-week" : "week"
    "scroll" : "scrolling"

  # Rendering functions

  renderWeekCalendar: () ->
    view = new Gandalf.Views.Events.CalendarWeek(
      startDate: moment(@startDate)
      days: @days
    )
    @$("#calendar-container").append(view.el)
    if @first
      @$("#calendar-container").animate scrollTop: 400, 1000
      @first = false

  renderMonthCalendar: () ->
    view = new Gandalf.Views.Events.CalendarMonth(
      startDate: moment(@startDate)
      days: @days
    )
    @$("#calendar-container").append(view.el)

  renderFeed: () ->
    _.each @days, (events, day) =>
      @addFeedDay(day, events)

  addFeedDay: (day, events) ->
    view = new Gandalf.Views.Events.FeedDay(day: day, collection: events)
    @$("#feed-list").append(view.el)

  renderSubscribedOrganizations: ->
    subscriptions = Gandalf.currentUser.get('subscribed_organizations')
    for s in subscriptions
      view = new Gandalf.Views.Organizations.Short(model: s)
      $("#subscribed-organizations-list").append(view.el)
  
  renderSubscribedCategories: ->
    subscriptions = Gandalf.currentUser.get('subscribed_categories')
    for s in  subscriptions
      view = new Gandalf.Views.Categories.Short(model: s)
      $("#subscribed-categories-list").append(view.el)

  renderCalendar: () ->
    header = @calHeaderTemplate(startDate: @startDate, period: @period)
    cs = ["cal-week", "cal-month"]
    if @period == "week" then addIndex = 0 else addIndex = 1
    @$("#calendar-container").html(header)
    @$("#calendar-container").removeClass(cs[(addIndex+1)%2]).addClass(cs[addIndex])
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

  next: () ->
    @startDate.add('w', 1)
    @renderCalendar()

  prev: () ->
    @startDate.subtract('w', 1)
    @renderCalendar()

  month: () ->
    @period = "month"
    @renderCalendar()

  week: () ->
    @period = "week"
    @renderCalendar()

  today: () ->
    if @period is "week"
      @startDate = moment().day(0)
    else
      @startDate = moment().date(1)
    @renderCalendar()

  scrolling: ->
    if("#feed-list").scrollTop() + $(".feed").height() == $("#feed-list").height()
      console.log 'go!'

  # Helpers

  adjustOverlappingEvents: () ->
    # If an event overlaps with one other, they both get class 'overlap-2', etc. for 3, 4
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
    pLeft = 3
    calZ = 10
    while overlapIndex <= @maxOverlaps
      selector = ".cal-week-event.overlap-#{overlapIndex}"
      selector += ":not(.event-hidden-org, .event-hidden-cat)"
      evs = $(selector)
      width = Math.floor(100/overlapIndex) - overlapIndex
      $(evs).css({ width: "#{width}%", paddingLeft: "#{pLeft}%" })
      _.each evs, (e, index) ->
        if index%overlapIndex is 0
          $(e).css(
            left: 0
            paddingLeft: 0
            width: "#{width + pLeft}%"
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