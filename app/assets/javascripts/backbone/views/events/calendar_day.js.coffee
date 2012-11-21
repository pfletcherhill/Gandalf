Gandalf.Views.Events ||= {}

class Gandalf.Views.Events.CalendarDay extends Backbone.View

  initialize: ->
    _.bindAll(@)

  template: JST["backbone/templates/events/calendar_day"]
  tagName: "td"
  className: "cal-day"

  render: (events) ->
    $(@el).html(@template())
    if events
      container = $(@el).children(".cal-events")[0]
      _.each events, (e) ->
        view = new Gandalf.Views.Events.CalendarEvent()
        $(container).append(view.render(e).el)

    return this
