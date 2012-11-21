Gandalf.Views.Events ||= {}

class Gandalf.Views.Events.Index extends Backbone.View
  template: JST["backbone/templates/events/index"]

  id: "index"

  initialize: ->
    _.bindAll(@)
    # Gandalf.currentUser.fetchSubscribedOrganizations().then @renderSubscribedOrganizations
    # Gandalf.currentUser.fetchSubscribedCategories().then @renderSubscribedCategories

  renderWeekCalendar: (events, start_date) ->
    days = _.groupBy(events.models, (event) ->
      return event.get('date')
    )
    view = new Gandalf.Views.Events.CalendarWeek()
    @$("#calendar-container").append(view.render(moment(start_date)).el)
    day_count = 0
    while day_count < 7
      d = moment(start_date).add('d', day_count).format("YYYY-MM-DD")
      @addCalDay(days[d])
      day_count++

  addCalDay: (events) ->
    view = new Gandalf.Views.Events.CalendarDay()
    @$("#cal-day-container").append(view.render(events).el)

  renderFeed: (events) ->
    days = _.groupBy(events.models, (event) ->
      return event.get('date')
    )
    _.each days, (events, day) =>
      @addFeedDay(day, events)

  addFeedDay: (day, events) ->
    view = new Gandalf.Views.Events.FeedDay()
    @$("#feed-list").prepend(view.render(day, events).el)
    
  render: (events, start, period) ->
    $(@el).html(@template({user: Gandalf.currentUser}))
    @renderFeed(events)
    if period == "month"
      @renderMonthCalendar(events, moment(start))
    else 
      @renderWeekCalendar(events, moment(start))
    return this
    
  renderSubscribedOrganizations: ->
    subscriptions = Gandalf.currentUser.get('subscribed_organizations')
    _.each subscriptions, (subscription) ->
      view = new Gandalf.Views.Organizations.Short(model: subscription)
      @$("#subscribed_organizations_list").append(view.render().el)
  
  renderSubscribedCategories: ->
    subscriptions = Gandalf.currentUser.get('subscribed_categories')
    _.each subscriptions, (subscription) ->
      view = new Gandalf.Views.Categories.Short(model: subscription)
      @$("#subscribed_categories_list").append(view.render().el)
  
  events:
    'scroll' : 'scrolling'
  
  scrolling: ->
    console.log 'scrolling'
    if("#events_list").scrollTop() + $(".feed").height() == $("#events_list").height()
      console.log 'go!'
    