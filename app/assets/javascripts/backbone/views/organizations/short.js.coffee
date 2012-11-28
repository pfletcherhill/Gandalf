Gandalf.Views.Organizations ||= {}

class Gandalf.Views.Organizations.Short extends Backbone.View
  template: JST["backbone/templates/organizations/short"]
  
  initialize: ->
    @render()
    @$('input').tooltip(
      placement: 'left'
      title: 'Toggle visibility'
    )

  className: "sidebar-item organization"
  events:
    "click input" : "clicked"
    
  render: =>
    $(@el).html(@template({m: @model, invisible: @options.invisible}))
    @$el.addClass("hidden") if @options.invisible
    return this

  clicked: () ->
    @$el.toggleClass("hidden")
    # Tells models/event.js to update shown organizations
    Gandalf.dispatcher.trigger("organizationShort:click", @model.id)
    Gandalf.dispatcher.trigger("popovers:hide")