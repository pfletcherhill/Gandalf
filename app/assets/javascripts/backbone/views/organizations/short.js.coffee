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
    # Tells models/event.js to update shown organizations
    Gandalf.dispatcher.trigger("organizationShort:click", @model.id)
    Gandalf.dispatcher.trigger("popovers:hide")