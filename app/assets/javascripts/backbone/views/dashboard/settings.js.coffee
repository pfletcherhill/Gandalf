Gandalf.Views.Dashboard ||= {}

class Gandalf.Views.Dashboard.Settings extends Backbone.View
  
  template: JST["backbone/templates/dashboard/settings/index"]
  
  id: 'organization'
    
  initialize: =>
    @render()
  
  render: ->
    $(@el).html(@template( @model.toJSON() ))