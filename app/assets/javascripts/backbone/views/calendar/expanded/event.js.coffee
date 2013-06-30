Gandalf.Views.Calendar.Expanded ||= {}

class Gandalf.Views.Calendar.Expanded.Event extends Backbone.View

  initialize: ()->
    @color = "rgba(#{@model.get("color")},1)"
    @lightColor = "rgba(#{@model.get("color")},0.7)"
    @eventId = @model.get("eventId")
    @dayNum = @options.dayNum 
    @hourHeight = Gandalf.calendarHeight / 24.0
    @css = {}
    @css.backgroundColor = @color
    @css.lightBackgroundColor = @lightColor
    @css.zIndex = @$el.css("zIndex")
    Gandalf.dispatcher.on("feed:event:mouseenter", @mouseenter, this)
    Gandalf.dispatcher.on("feed:event:mouseleave", @mouseleave, this)
    Gandalf.dispatcher.on("feed:event:click", @click, this)
    @render()

  template: JST["backbone/templates/calendar/expanded/event"]

  # This element is an li so that :nth-of-type works properly in the CSS
  tagName: "div"
  className: "js-event cal-event cal-week-event"
  attributes: 
    rel: "event-popover"
  # hourHeight: 45
  popoverChild: ".event-name:first"

  events:
    "click": "click"
    "mouseenter" : "mouseenter"
    "mouseleave" : "mouseleave"

  getPosition: (time) ->
    t = moment(time)
    hours = t.hours() + t.minutes()/60
    return Math.floor(hours*@hourHeight)

  render: () ->
    e = @model
    @top = @getPosition e.get("calStart")
    @height = @getPosition(e.get("calEnd")) - @top
    @$el
      .css(
        top: "#{@top}px"
        height: "#{@height}px"
        backgroundColor: @lightColor
        border: "1pt solid #{@color}"
      ).attr(
        "data-event-id": e.get("id") # Should be unique per visual event
        "data-organization-id" : e.get("organization_id")
        "data-category-ids" : e.makeCatIdString()
      ).html(@template( event: e ))
    @$el.addClass("day-#{@dayNum}")
    return this

  click: (id) ->
    return if typeof id is "number" and @eventId isnt id
    m = @model
    eId = m.get("eventId")
    if m.get("id") isnt eId
      m = @options.calEvents.get(eId)

    Gandalf.dispatcher.trigger("event:click", 
      { model: m, color: @lightColor })

  mouseenter: (id) ->
    return if typeof id is "number" and @eventId isnt id
    # Store current CSS values
    @css.width = @$el.css("width")
    # @css.pLeft = @$el.css("paddingLeft")
    @css.left = @$el.css("left")
    @css.zIndex = @$el.css("zIndex")
    @$el.css(
      width: "97%"
      padding: 0
      left: 0
      zIndex: 19
      backgroundColor: @color
      border: "1pt solid #333"
    )
  mouseleave: (id)->
    return if typeof id is "number" and @eventId isnt id
    @$el.css(
      width: @css.width
      # paddingLeft: @css.pLeft
      left: @css.left
      zIndex: @css.zIndex
      backgroundColor: @lightColor
      border: "1pt solid #{@color}"
    )
