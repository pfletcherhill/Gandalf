Gandalf.Views.Events ||= {}

class Gandalf.Views.Events.Show extends Backbone.View
  
  template: JST["backbone/templates/events/show"]
  
  el: '#content'
  
  initialize: ->
    @render()
  
            
  render: ->
    $(@el).html(@template( event: @model ))
    return this