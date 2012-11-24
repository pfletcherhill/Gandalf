Gandalf.Views.Events ||= {}

class Gandalf.Views.Events.CalendarWeek extends Backbone.View
  initialize: ()->
    Gandalf.dispatcher.on("popovers:hide", @hidePopovers)
    @render()

  template: JST["backbone/templates/events/calendar_week"]
  
  tagName: "div"
  className: "cal week-cal"

  events:
    "click .hour-day" : "hidePopovers"
  
  render: () ->
    $(@el).html(@template())
    return this

  hidePopovers: () ->
    $("[rel='event-popover']").popover("hide")


