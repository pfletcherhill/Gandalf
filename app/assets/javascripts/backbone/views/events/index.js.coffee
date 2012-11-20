Gandalf.Views.Events ||= {}

class Gandalf.Views.Events.Index extends Backbone.View
  template: JST["backbone/templates/events/index"]
  
  initialize: ->
  
  addAll: (events) ->
    _.each events.models, (event) =>
      @addOne(event)

  addOne: (event) ->
    view = new Gandalf.Views.Events.Show({model: event})
    @$("#events_list").prepend(view.render().el)
    
  render: (events) ->
    $(@el).html(@template(user: Gandalf.currentUser))
    @addAll(events)
    return this
    
    