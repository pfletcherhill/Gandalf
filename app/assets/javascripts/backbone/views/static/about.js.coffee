Gandalf.Views.Static ||= {}

class Gandalf.Views.Static.About extends Backbone.View
  template: JST["backbone/templates/static/about"]
  
  initialize: ->
    
  render: =>
    $(@el).html(@template())
    return this