Gandalf.Views.Dashboard ||= {}

class Gandalf.Views.Dashboard.Event extends Backbone.View

  initialize: ->
    @render()

  tagName: "tr"
  className: "organization-event"

  template: JST["backbone/templates/dashboard/events/show"]

  events:
    "click .btn.edit" : "edit"
    "click .btn.delete" : "deleteEvent"

  render: ->
    @$el
      .attr("data-id", event.id)
      .html @template(event: @model)
    return this

  # Event handlers

  edit: ->
    Gandalf.dispatcher.trigger("event:edit", @model)

  deleteEvent: ->
    Gandalf.dispatcher.trigger("event:delete", @model)

