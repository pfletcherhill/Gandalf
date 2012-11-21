Gandalf.Views.Users ||= {}

class Gandalf.Views.Users.Preferences extends Backbone.View
  template: JST["backbone/templates/users/preferences"]
  
  initialize: ->
    
  render: =>
    $(@el).html(@template())
    return this