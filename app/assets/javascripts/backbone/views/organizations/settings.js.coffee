Gandalf.Views.Organizations ||= {}

class Gandalf.Views.Organizations.Settings extends Backbone.View
  
  template: JST["backbone/templates/organizations/settings/index"]
  
  id: 'organization'
    
  initialize: =>
    @render()
  
  render: ->
    $(@el).html(@template( @model.toJSON() ))