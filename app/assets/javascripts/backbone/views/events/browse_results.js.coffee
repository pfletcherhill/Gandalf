Gandalf.Views.Events ||= {}

class Gandalf.Views.Events.BrowseResult extends Backbone.View
  
  template: JST["backbone/templates/events/browse_result"]
  
  className: "browse-result"
  
  initialize: ->
    
  render: ->
    $(@el).html(@template( result: @model ))
    return this