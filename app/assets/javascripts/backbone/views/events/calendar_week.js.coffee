Gandalf.Views.Events ||= {}

class Gandalf.Views.Events.CalendarWeek extends Backbone.View
  template: JST["backbone/templates/events/calendar_week"]
  
  tagName: "div"
  className: "cal week-cal"

  events:
    "click .hour-day" : "hidePopovers"
  
  initialize: ()->
    @render()

  render: () ->
    $(@el).html(@template(startDate: @options.startDate))
    return this

  hidePopovers: () ->
    $("[rel='event-popover']").popover("hide")
