Gandalf.Views.Events ||= {}

class Gandalf.Views.Events.DayCalendar extends Backbone.View
  template: JST["backbone/templates/events/day_calendar"]

  render: (events) ->
    $(@el).html(@template(events))
    return this