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
    _.each days, (events, day) ->
      @addCalDay(day, events, tag)

  addCalDay: (day, events) ->
    view = new Gandalf.Views.Events.CalDay()
    $("#calendar-container").html(view.render(day, events).el)

  renderFeed: (events) ->
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
    @renderFeed(events)
    @renderWeekCalendar(events)
    return this
    
  renderSubscribedOrganizations: ->
    subscriptions = Gandalf.currentUser.get('subscribed_organizations')
    _.each subscriptions, (subscription) ->
      view = new Gandalf.Views.Organizations.Short(model: subscription)
      @$("#subscribed_organizations_list").prepend(view.render().el)
  
  renderSubscribedCategories: ->
    subscriptions = Gandalf.currentUser.get('subscribed_categories')
    _.each subscriptions, (subscription) ->
      view = new Gandalf.Views.Categories.Short(model: subscription)
      @$("#subscribed_categories_list").prepend(view.render().el)
  
  events:
    'scroll' : 'scrolling'
  
  scrolling: ->
    console.log 'scrolling'
    if("#events_list").scrollTop() + $(".feed").height() == $("#events_list").height()
      console.log 'go!'
    