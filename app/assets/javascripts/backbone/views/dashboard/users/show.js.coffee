Gandalf.Views.Dashboard ||= {}

class Gandalf.Views.Dashboard.User extends Backbone.View

  initialize: ->
    @render()

  tagName: "tr"
  className: "dash-row user striped"

  template: JST["backbone/templates/dashboard/users/show"]

  events:
    "click [type=checkbox]" : "broadcastSelect"

  render: ->
    @$el
      .attr("data-id", @model.id)
      .html @template(user: @model, index: @options.index)
    $("[rel=tooltip]").tooltip(
      placement: 'right'
    )
    return this

  # Event handlers

  edit: ->
    Gandalf.dispatcher.trigger("event:edit", @model)

  deleteEvent: ->
    Gandalf.dispatcher.trigger("event:delete", @model)

  broadcastSelect: ->
    Gandalf.dispatcher.trigger("dashboard:user:checkbox")

