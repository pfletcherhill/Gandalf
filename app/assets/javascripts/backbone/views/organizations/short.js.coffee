Gandalf.Views.Organizations ||= {}

class Gandalf.Views.Organizations.Short extends Backbone.View
  template: JST["backbone/templates/organizations/short"]
  
  initialize: ->
    @render()

  className: "sidebar-item organization"
  events:
    "click" : "clicked"
    
  render: =>
    $(@el).html(@model.name)
    return this

  clicked: () ->
    @$el.toggleClass("hidden")
    Gandalf.dispatcher.trigger("organizationShort:click", @model.id)