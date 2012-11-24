Gandalf.Views.Events ||= {}

class Gandalf.Views.Events.CalendarDay extends Backbone.View

  initialize: ->
    _.bindAll(@)
    @render()

  template: JST["backbone/templates/events/calendar_day"]
  tagName: "td"
  className: "cal-day"


  render: () ->
    calEvents = @model
    $(@el).html(@template()) # Add the calendar day
    if calEvents
      container = $(@el).children(".cal-events:first")
      for e in calEvents
        view = new Gandalf.Views.Events.CalendarEvent(model: e)
        $(container).append(view.el)

    return this
