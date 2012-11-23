Gandalf.Views.Events ||= {}

class Gandalf.Views.Events.CalendarEvent extends Backbone.View

  initialize: ()->
    _.bindAll(@)
    @render()
    @$el.popover(
      placement: 'left'
      content: 'My content'
      title: 'A title'
    )

  template: JST["backbone/templates/events/calendar_event"]
  
  # This element is an li so that :nth-of-type works properly in the CSS
  tagName: "li"
  className: "cal-event"
  attributes: 
    rel: "event-popover"
  hourHeight: 45
  popoverChild: ".event-name:first"

  events:
    "click": "showPopover"
    "click:feedEvent" : "showPopover"

  getPosition: (time) ->
    t = moment(time)
    hours = t.hours() + t.minutes()/60
    return Math.floor(hours*@hourHeight)

  render: () ->
    e = @model
    top = @getPosition e.get("start_at")
    height = @getPosition(e.get("end_at")) - top
    style_string = "top: "+top+"px; height: "+height+"px;"
    $(@el).attr({ style: style_string, "data-id": e.get("id") }).html(@template(
      event: e
      top: top
      height: height
    ))
    return this

  showPopover: () ->
    id = @model.get("id")
    # Hide all other popovers
    $("[rel='event-popover']:not([data-id='"+id+"'])").popover("hide")
    # Toggle this one
    @$el.popover('toggle')

