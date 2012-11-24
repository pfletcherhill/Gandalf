Gandalf.Views.Events ||= {}

class Gandalf.Views.Events.Index extends Backbone.View

  # options has keys [collection, startDate, period]
  initialize: ()->
    _.bindAll(this, "adjustOverlappingEvents")
    Gandalf.currentUser.fetchSubscribedOrganizations().then @renderSubscribedOrganizations
    Gandalf.currentUser.fetchSubscribedCategories().then @renderSubscribedCategories
    # Listening for global events
    Gandalf.dispatcher.bind("event:changeVisible", @adjustOverlappingEvents)
    @startDate = @options.startDate
    @period = @options.period
    @render()

  template: JST["backbone/templates/events/index"]
  calHeaderTemplate: JST["backbone/templates/events/calendar_header"]

  el: "#content"

  events: 
    "click #cal-next" : "next"
    "click #cal-prev" : "prev"
    "scroll" : "scrolling"

  renderWeekCalendar: () ->
    header = @calHeaderTemplate(startDate: @startDate)
    @$("#calendar-container").html(header)
    view = new Gandalf.Views.Events.CalendarWeek(startDate: moment(@startDate))
    @$("#calendar-container").append(view.el)

  renderMonthCalendar: () ->
    view = new Gandalf.Views.Events.CalendarWeek(startDate: moment(@startDate))
    @$("#calendar-container").html(view.el)

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

  adjustOverlappingEvents: (eventId) ->
    overlaps = @collection.findOverlaps eventId 
    $(".cal-event").removeClass("overlap overlap-1 overlap-2 overlap-3")
    _.each overlaps, (ids, myId) ->
      len = ids.length
      # keep this line in case i need it later
      # $(".cal-event[data_id='"+myId+"']").addClass "overlap-"+len+" overlap-order-"+0 
      $(".cal-event[data-event-id='"+myId+"']").addClass "overlap overlap-"+len
      _.each ids, (id, i) ->
        num = i+1
        $(".cal-event[data-event-id='"+id+"']").addClass "overlap overlap-"+len

  renderCalendar: () ->
    if @period == "month"
      @renderMonthCalendar()
      @numDays = 28 # ACTUALLy number of days in the month of moment(start)
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
    

  renderSubscribedOrganizations: ->
    subscriptions = Gandalf.currentUser.get('subscribed_organizations')
    _.each subscriptions, (subscription) ->
      view = new Gandalf.Views.Organizations.Short(model: subscription)
      @$("#subscribed-organizations-list").append(view.render().el)
  
  renderSubscribedCategories: ->
    subscriptions = Gandalf.currentUser.get('subscribed_categories')
    _.each subscriptions, (subscription) ->
      view = new Gandalf.Views.Categories.Short(model: subscription)
      @$("#subscribed-categories-list").append(view.render().el)
  
  next: () ->
    @startDate.add('w', 1)
    @renderCalendar()

  prev: () ->
    @startDate.subtract('w', 1)
    @renderCalendar()



  # Paul, this code should be in 
  scrolling: ->
    if("#feed-list").scrollTop() + $(".feed").height() == $("#feed-list").height()
      console.log 'go!'
    