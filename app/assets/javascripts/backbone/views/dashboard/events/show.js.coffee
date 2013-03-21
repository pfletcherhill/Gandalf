Gandalf.Views.Dashboard ||= {}

class Gandalf.Views.Dashboard.Event extends Backbone.View

  initialize: ->
    @render()
    @model.on("change", @render)

  tagName: "tr"
  className: "dash-row event"

  template: JST["backbone/templates/dashboard/events/show"]

  events:
    "click .edit" : "edit"
    "click .delete" : "deleteEvent"

  render: () =>
    @$el
      .attr("data-id", @model.id)
      .html @template(event: @model)
    $("[rel=tooltip]").tooltip(
      placement: 'right'
    )
    return this

  # Event handlers

  edit: ->
    Gandalf.dispatcher.trigger("event:edit"
      event: @model
      collection: @collection
    )

  deleteEvent: ->
    name = @model.get("name")
    if confirm("Are you sure you want to delete #{@model.get('name')}?")
      @model.destroy(success: =>
        Gandalf.dispatcher.trigger("flash:success", "#{name} deleted!")
      )

