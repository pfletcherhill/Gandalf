Gandalf.Views.Events ||= {}

class Gandalf.Views.Events.Index extends Backbone.View
  template: JST["backbone/templates/events/index"]
  
  initialize: ->
  
  addAll: (events) ->
    # Why is this a double arrow?
    _.each events.models, (event) =>
      @addOne(event)

  addOne: (event) ->
    view = new Gandalf.Views.Events.Show({model: event})
    @$("#events_list").prepend(view.render().el)
    
  render: (events) ->
    $(@el).html(@template())
    @addAll(events)
    return this
    
    