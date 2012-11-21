Gandalf.Views.Events ||= {}

class Gandalf.Views.Events.CalendarEvent extends Backbone.View

  initialize: ->
    _.bindAll(@)

  template: JST["backbone/templates/events/calendar_event"]
  tagName: "div"
  className: "cal-event"

  hourHeight: 45

  get_position: (time) ->
    t = moment(time)
    hours = t.hours() + t.minutes()/60
    return Math.floor(hours*@hourHeight)


  render: (e) ->
    attrs = e.attributes
    top = @get_position attrs.start_at
    height = @get_position(attrs.end_at) - top
    style_string = "top: "+top+"px; height: "+height+"px;"

    $(@el).attr({style: style_string, data_id: attrs.id}).html(@template(
      params: attrs
      top: top
      height: height
    ))
    return this

# <div class="cal-event" style="top: <%= top %>px; height: <%= height %>px;">
