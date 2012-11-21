Gandalf.Views.Events ||= {}

class Gandalf.Views.Events.Show extends Backbone.View
  template: JST["backbone/templates/events/show"]
  
  initialize: ->
  
  convertTime: (time) ->
    date = moment(time).format("h:mm a")
    date
    
  render: =>
    time = @convertTime @model.get('start_at')
    $(@el).html(@template( event: @model.toJSON(), time: time ))
    return this
    