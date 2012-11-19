Gandalf.Views.Events ||= {}

class Gandalf.Views.Events.Show extends Backbone.View
  template: JST["backbone/templates/events/show"]
  
  initialize: ->
    
  render: =>
    $(@el).html(@template( @model.toJSON() ))
    return this
    