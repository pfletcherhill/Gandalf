Gandalf.Views.Categories ||= {}

class Gandalf.Views.Categories.Short extends Backbone.View
  template: JST["backbone/templates/categories/short"]
  
  initialize: ->
    @render()

  className: "sidebar-item category"
  events:
    "click" : "clicked"
  render: =>
    $(@el).html(@model.name)
    return this

  clicked: () ->
    @$el.toggleClass("hidden")
    # Tells models/event.js to update shown categories
    Gandalf.dispatcher.trigger("categoryShort:click", @model.id)
    Gandalf.dispatcher.trigger("popovers:hide")
