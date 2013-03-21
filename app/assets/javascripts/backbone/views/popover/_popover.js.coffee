Gandalf.Views ||= {}

class Gandalf.Views.Popover extends Backbone.View

  initialize: ->
    # My events are the events on the currently shown calendar
    @myEvents = @options.events
    # All popover event handlers
    Gandalf.dispatcher.on("popover:hide", @hide, this)
    Gandalf.dispatcher.on("route", @hide, this)
    Gandalf.dispatcher.on("popover:eventsReady", @setEvents, this)
    @render()

  id: "popover-container"
  template: JST["backbone/templates/popover/index"]

  events:
    "click .global-overlay,.close,a" : "hide"

  render: ->
    @$el.html @template()
    return this

  setEvents: (evs) ->
    console.log "popover: setting events...", evs
    @myEvents = evs

  # Helpers

  show: ->
    $(".gandalf-popover,.global-overlay").fadeIn "fast"

  hide: ->
    $(".gandalf-popover,.global-overlay").fadeOut("fast")