Gandalf.Views.Events ||= {}

class Gandalf.Views.Events.CalendarDay extends Backbone.View

  initialize: ->
    _.bindAll(@)

  template: JST["backbone/templates/events/calendar_day"]
  tagName: "td"
  className: "cal-day"


  render: (events) ->

    $(@el).html(@template()) # Add the calendar day
    if events
      container = $(@el).children(".cal-events:first")
      _.each events, (e) ->  # Add each of its events
        view = new Gandalf.Views.Events.CalendarEvent(e)
        $(container).append(view.el)

    return this
