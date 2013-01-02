Gandalf.Views.Preferences ||= {}

class Gandalf.Views.Preferences.Index extends Backbone.View
  template: JST["backbone/templates/preferences/index"]
  
  initialize: ->
    
  render: =>
    $(@el).html(@template())
    return this