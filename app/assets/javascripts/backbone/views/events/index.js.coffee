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
    view = new Gandalf.Views.Events.CalendarWeek(startDate: moment(@startDate))
    @$("#calendar-container").append(view.el)
    @$("#calendar-container").animate scrollTop: 350, 1000

  renderMonthCalendar: () ->
    view = new Gandalf.Views.Events.CalendarWeek(startDate: moment(@startDate))
    @$("#calendar-container").append(view.el)

  renderCalDays: () ->
    dayCount = 0
    while dayCount < @numDays
      # Gandalf.eventKeyFormat was set when the app was initialized
      d = moment(@startDate).add('d', dayCount).format(Gandalf.eventKeyFormat)
      @addCalDay(@days[d])
      dayCount++

  addCalDay: (events) ->
    view = new Gandalf.Views.Events.CalendarDay(model: events)
    @$("#cal-day-container").append(view.el)

  renderFeed: () ->
    _.each @days, (events, day) =>
      @addFeedDay(day, events)

  addFeedDay: (day, events) ->
    view = new Gandalf.Views.Events.FeedDay(day: day, collection: events)
    @$("#feed-list").append(view.el)

  renderSubscribedOrganizations: ->
    subscriptions = Gandalf.currentUser.get('subscribed_organizations')
    for s in  subscriptions
      view = new Gandalf.Views.Organizations.Short(model: subscription)
      $("#subscribed-organizations-list").append(view.el)
  
  renderSubscribedCategories: ->
    subscriptions = Gandalf.currentUser.get('subscribed_categories')
    for s in  subscriptions
      view = new Gandalf.Views.Categories.Short(model: s)
      $("#subscribed-categories-list").append(view.el)

  renderCalendar: () ->
    header = @calHeaderTemplate(startDate: @startDate, period: @period)
    @$("#calendar-container").html(header)
    if @period == "month"
      @renderMonthCalendar()
      @numDays = @startDate.daysInMonth()
    else 
      @renderWeekCalendar()
      @numDays = 7
    @renderCalDays()
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
    overlaps = @collection.findOverlaps()
    $(".cal-event").removeClass("overlap-2 overlap-3 overlap-4")
    for ids, myId in overlaps
      num = ids.length + 1
      $(".cal-event[data-event-id='#{myId}']").addClass "overlap overlap-#{num}"
      for id in ids
        $(".cal-event[data-event-id='#{id}']").addClass "overlap overlap-#{num}"
    @makeCSSAdjustments()

  # CSS wasn't strong enough for the kind of styling I wanted to do...
  # so we're doing it in JS
  makeCSSAdjustments: () ->
    overlapIndex = 2
    pLeft = 3
    calZ = 10
    while overlapIndex <= @maxOverlaps
      evs = $(".cal-event.overlap-#{overlapIndex}:not(.event-hidden-org, .event-hidden-cat)")
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