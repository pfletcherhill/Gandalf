Gandalf.Views.Events ||= {}

class Gandalf.Views.Events.Show extends Backbone.View
  template: JST["backbone/templates/events/show"]
  
  initialize: ->
  
  convertTime: (time) ->
    moment(time).format("h:mm a")
    
  render: =>
    time = @convertTime @model.get('start_at')
    $(@el).html(@template( event: @model.toJSON(), time: time ))
    return this
    