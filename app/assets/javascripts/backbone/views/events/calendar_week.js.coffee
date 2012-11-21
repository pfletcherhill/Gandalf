Gandalf.Views.Events ||= {}

class Gandalf.Views.Events.CalendarWeek extends Backbone.View
  template: JST["backbone/templates/events/calendar_week"]
  tagName: "div"
  className: "cal week-cal"
    
  render: (start_date) ->
    $(@el).html(@template(start_date: start_date))
    return this