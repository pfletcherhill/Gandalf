Gandalf.Views.Organizations ||= {}

class Gandalf.Views.Organizations.Index extends Backbone.View
  template: JST["backbone/templates/organizations/index"]
  
  initialize: ->
    
  render: =>
    $(@el).html(@template())
    return this