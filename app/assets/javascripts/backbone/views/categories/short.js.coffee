Gandalf.Views.Categories ||= {}

class Gandalf.Views.Categories.Short extends Backbone.View
  template: JST["backbone/templates/categories/short"]
  
  initialize: ->
    
  render: =>
    $(@el).html(@template( @model ))
    return this