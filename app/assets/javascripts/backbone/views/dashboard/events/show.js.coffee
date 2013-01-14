Gandalf.Views.Dashboard ||= {}

class Gandalf.Views.Dashboard.Event extends Backbone.View

  initialize: ->
    @render()

  tagName: "tr"
  className: "dash-row event"

  template: JST["backbone/templates/dashboard/events/show"]

  events:
    "click .edit" : "edit"
    "click .delete" : "deleteEvent"

  render: ->
    @$el
      .attr("data-id", @model.id)
      .html @template(event: @model)
    $("[rel=tooltip]").tooltip(
      placement: 'right'
    )
    return this

  # Event handlers

  edit: ->
    Gandalf.dispatcher.trigger("event:edit", @model)

  deleteEvent: ->
    confirm("Are you sure you want to delete #{@model.get('name')}?")
    # Gandalf.dispatcher.trigger("event:delete", @model)
    # Delete it

