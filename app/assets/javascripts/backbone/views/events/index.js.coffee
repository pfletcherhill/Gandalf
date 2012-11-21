Gandalf.Views.Events ||= {}

class Gandalf.Views.Events.Index extends Backbone.View
  template: JST["backbone/templates/events/index"]
  
  initialize: ->
    Gandalf.currentUser.fetchSubscribedOrganizations().then @renderSubscribedOrganizations
    Gandalf.currentUser.fetchSubscribedCategories().then @renderSubscribedCategories

  addWeekCalendar: (events) ->
    days = _.groupBy(events.models, (event) ->
      return event.get('date')
    )
    view = new Gandalf.Views.Events.WeekCalendar()
    $("#calendar-container").html(view.render(day, events).el)
    _.each days, (events, day) =>
      @addCalDay(day, events)

  addCalDay: (day, events) ->
    view = new Gandalf.Views.Events.CalDay()
    $("#calendar-container").html(view.render(day, events).el)

  addFeed: (events) ->
    days = _.groupBy(events.models, (event) ->
      return event.get('date')
    )
    _.each days, (events, day) =>
      @addFeedDay(day, events)

  addFeedDay: (day, events) ->
    view = new Gandalf.Views.Events.Day()
    @$("#events_list").prepend(view.render(day, events).el)
    
  render: (events) ->
    $(@el).html(@template(user: Gandalf.currentUser))
    @addFeed(events)
    @addWeekCalendar(events)
    return this
    
  renderSubscribedOrganizations: ->
    subscriptions = Gandalf.currentUser.get('subscribed_organizations')
    console.log subscriptions
  
  renderSubscribedCategories: ->
    subscriptions = Gandalf.currentUser.get('subscribed_categories')
    console.log subscriptions
    