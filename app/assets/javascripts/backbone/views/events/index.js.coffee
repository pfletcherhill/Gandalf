Gandalf.Views.Events ||= {}

class Gandalf.Views.Events.Index extends Backbone.View
  template: JST["backbone/templates/events/index"]
  
  initialize: ->
    Gandalf.currentUser.fetchSubscribedOrganizations().then @renderSubscribedOrganizations
    Gandalf.currentUser.fetchSubscribedCategories().then @renderSubscribedCategories
  
  addFeed: (events) ->
    days = _.groupBy(events.models, (event) ->
        return event.get('date')
    )
    _.each days, (events, day) =>
      @addDay(day, events)

  addDay: (day, events) ->
    view = new Gandalf.Views.Events.Day()
    @$("#events_list").append(view.render(day, events).el)
    
  render: (events) ->
    $(@el).html(@template(user: Gandalf.currentUser))
    @addFeed(events)
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
    