Gandalf.Views.Organizations ||= {}

class Gandalf.Views.Organizations.Short extends Backbone.View
  template: JST["backbone/templates/organizations/short"]
  
  initialize: ->
    
  render: =>
    $(@el).html(@template( @model ))
    return this