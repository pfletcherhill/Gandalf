Gandalf.Views.Events ||= {}

class Gandalf.Views.Events.WeekCalendar extends Backbone.View
  template: JST["backbone/templates/events/week_calendar"]

  render: (start_date) ->
    $(@el).html(@template(start_date))
    return this