Gandalf.Views.Events ||= {}

class Gandalf.Views.Events.Index extends Backbone.View
  template: JST["backbone/templates/events/index"]

  el: "#content"

  initialize: (events, start, period)->
    Gandalf.currentUser.fetchSubscribedOrganizations().then @renderSubscribedOrganizations
    Gandalf.currentUser.fetchSubscribedCategories().then @renderSubscribedCategories
    @render(events, start, period)

  renderWeekCalendar: (startDate) ->
    view = new Gandalf.Views.Events.CalendarWeek(startDate)
    @$("#calendar-container").html(view.el)

  renderMonthCalendar: (startDate) ->
    view = new Gandalf.Views.Events.CalendarWeek(startDate)
    @$("#calendar-container").html(view.el)

  renderCalDays: (days, startDate, numDays) ->
    dayCount = 0
    while dayCount < numDays
      # Gandalf.eventKeyFormat was set when the app was initialized
      d = moment(startDate).add('d', dayCount).format(Gandalf.eventKeyFormat)
      @addCalDay(days[d])
      dayCount++

  addCalDay: (events) ->
    view = new Gandalf.Views.Events.CalendarDay()
    @$("#cal-day-container").append(view.render(events).el)

  renderFeed: (days) ->
    _.each days, (events, day) =>
      @addFeedDay(day, events)

  addFeedDay: (day, events) ->
    view = new Gandalf.Views.Events.FeedDay()
    @$("#feed-list").append(view.render(day, events).el)

  # Doesn't work becuase jQuery selectors aren't working properly...
  adjustOverlappingEvents: (overlaps) ->
    _.each overlaps, (ids, myId) ->
      len = ids.length
      # keep this line in case i need it later
      # $(".cal-event[data_id='"+myId+"']").addClass "overlap-"+len+" overlap-order-"+0 
      $(".cal-event[data_id='"+myId+"']").addClass "overlap overlap-"+len
      _.each ids, (id, i) ->
        num = i+1
        $(".cal-event[data_id='"+id+"']").addClass "overlap overlap-"+len

    
  render: (events, start, period) ->
    $(@el).html(@template({ user: Gandalf.currentUser }))
    days = events.sortAndGroup()
    @renderFeed(days)
    if period == "month"
      @renderMonthCalendar moment(start)
      numDays = 28 # ACTUALLy number of days in the month of moment(start)
    else 
      @renderWeekCalendar moment(start)
      numDays = 7

    @renderCalDays(days, moment(start), numDays)
    overlaps = events.findOverlaps days
    @adjustOverlappingEvents overlaps
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
  
  events:
    'scroll' : 'scrolling'
  
  scrolling: ->
    console.log 'scrolling'
    if("#feed-list").scrollTop() + $(".feed").height() == $("#feed-list").height()
      console.log 'go!'
    