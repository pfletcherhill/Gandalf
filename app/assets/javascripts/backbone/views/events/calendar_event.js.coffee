Gandalf.Views.Events ||= {}

class Gandalf.Views.Events.CalendarEvent extends Backbone.View

  initialize: (event)->
    _.bindAll(@)
    @render(event)

  template: JST["backbone/templates/events/calendar_event"]
  
  tagName: "div"
  className: "cal-event"
  attributes: {}
  hourHeight: 45

  get_position: (time) ->
    t = moment(time)
    hours = t.hours() + t.minutes()/60
    return Math.floor(hours*@hourHeight)

  render: (e) ->
    top = @get_position e.get("start_at")
    height = @get_position(e.get("end_at")) - top
    style_string = "top: "+top+"px; height: "+height+"px;"

    $(@el).attr({ style: style_string, data_id: e.get("id") }).html(@template(
      event: e
      top: top
      height: height
    ))

    return this

