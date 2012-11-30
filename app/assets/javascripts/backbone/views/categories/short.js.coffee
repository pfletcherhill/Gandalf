Gandalf.Views.Categories ||= {}

class Gandalf.Views.Categories.Short extends Backbone.View
  template: JST["backbone/templates/organizations/short"]
  
  initialize: ->
    @render()

  className: "sidebar-item category"

  events:
    "click input" : "clicked"

  render: =>
    $(@el).html({m: @model, checked: @options.checked})
    @$el.addClass("hidden") if @options.checked
    return this

  clicked: () ->
    @$el.toggleClass("hidden")
    # Tells models/event.js to update shown categories
    Gandalf.dispatcher.trigger("categoryShort:click", @model.id)
    Gandalf.dispatcher.trigger("popovers:hide")
