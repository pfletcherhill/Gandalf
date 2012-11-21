Gandalf.Views.Events ||= {}

class Gandalf.Views.Events.DayCalendar extends Backbone.View
  template: JST["backbone/templates/events/day_calendar"]
  className: "cal-day"
  render: (events) ->
    console.log(events)
    $(@el).html(@template(events))
    return this