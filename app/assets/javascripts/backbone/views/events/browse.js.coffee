Gandalf.Views.Events ||= {}

class Gandalf.Views.Events.Browse extends Backbone.View
  
  template: JST["backbone/templates/events/browse"]
  
  initialize: ->
    
  render: () ->
    $(@el).html(@template())
    return this