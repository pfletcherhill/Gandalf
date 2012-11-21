Gandalf.Views.Events ||= {}

class Gandalf.Views.Events.Index extends Backbone.View
  template: JST["backbone/templates/events/index"]
  
  initialize: ->
    _.bindAll(@)
    # Gandalf.currentUser.fetchSubscribedOrganizations().then @renderSubscribedOrganizations
    # Gandalf.currentUser.fetchSubscribedCategories().then @renderSubscribedCategories

  renderWeekCalendar: (events, start_date) ->
    days = _.groupBy(events.models, (event) ->
      return event.get('date')
    )
    view = new Gandalf.Views.Events.WeekCalendar()
    $("#calendar-container").html(view.render(start_date).el)
    _.each days, (events, day) ->
      @addCalDay(day, events)

  addCalDay: (day, events) ->
    view = new Gandalf.Views.Events.CalDay()
    $("#cal-body").append(view.render(events).el)

  renderFeed: (events) ->
    days = _.groupBy(events.models, (event) ->
      return event.get('date')
    )
    _.each days, (events, day) =>
      @addFeedDay(day, events)

  addFeedDay: (day, events) ->
    view = new Gandalf.Views.Events.Day()
    @$("#events_list").append(view.render(day, events).el)
    
  render: (events, start, period) ->
    $(@el).html(@template(user: Gandalf.currentUser))
    @renderFeed(events)
    if period == "month"
      @renderMonthCalendar(events, start)
    else 
      @renderWeekCalendar(events, start)
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
    