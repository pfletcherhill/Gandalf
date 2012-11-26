Gandalf.Views.Events ||= {}

class Gandalf.Views.Events.CalendarWeekEvent extends Backbone.View

  initialize: ()->
    _.bindAll(@)
    @render()
    @$el.popover(
      placement: 'left'
      html: true
      trigger: 'click'
      content: @popoverTemplate(e: @model)
    )
    @css = {}
    @css.backgroundColor = @$el.css("backgroundColor")
    @css.zIndex = @$el.css("zIndex")
    Gandalf.dispatcher.on("feedEvent:mouseenter", @feedmouseenter)
    Gandalf.dispatcher.on("feedEvent:mouseleave", @feedmouseleave)
    Gandalf.dispatcher.on("feedEvent:click", @feedClick)

  template: JST["backbone/templates/calendar/calendar_week_event"]
  popoverTemplate: JST["backbone/templates/calendar/calendar_popover"]

  # This element is an li so that :nth-of-type works properly in the CSS
  tagName: "div"
  className: "js-event cal-event cal-week-event"
  attributes: 
    rel: "event-popover"
  hourHeight: 45
  popoverChild: ".event-name:first"

  events:
    "click": "onClick"
    "mouseenter" : "mouseenter"
    "mouseleave" : "mouseleave"

  getPosition: (time) ->
    t = moment(time)
    hours = t.hours() + t.minutes()/60
    return Math.floor(hours*@hourHeight)

  render: () ->
    e = @model
    @top = @getPosition e.get("start_at")
    @height = @getPosition(e.get("end_at")) - @top
    style_string = "top: #{@top}px; height: #{@height}px;"
    $(@el).attr(
      style: style_string
      "data-event-id": e.get("id")
      "data-organization-id" : e.get("organization_id")
      "data-category-ids" : e.makeCatIdString()
    ).html(@template( event: e ))
    return this

  onClick: () ->
    @scroll()
    @popover()

  scroll:() ->
    tHeight = 300 # popover height
    padTop = 50   # space above popover when scrolling to
    container = @$el.parents("#calendar-container")
    if @height > tHeight
      scrolltop = @top - padTop
    else
      scrolltop = @top + (@height-tHeight) / 2 - padTop
    $(container).animate scrollTop: scrolltop, 300


  popover: () ->
    id = @model.get("id")
    # Hide all other popovers
    otherPopovers = $("[rel='event-popover']:not([data-event-id='#{id}'])")
    otherPopovers.popover('hide') if otherPopovers
    # Add event handler to close button
    t = this
    $(".popover .close").click (e) ->
      t.$el.popover('hide')

  feedmouseenter: (id) ->
    if not id or @model.get("id") is id
      @$el.css(
        backgroundColor: "rgba(170,170,170,0.9)"
        zIndex: 15
      )

  feedmouseleave: (id) ->
    if not id or @model.get("id") is id
      @$el.css(
        backgroundColor: @css.backgroundColor
        zIndex: @css.zIndex
      )

  feedClick:(id) ->
    if not id or @model.get("id") is id
      @$el.click()

  mouseenter:() ->
    # Store current CSS values
    @css.width = @$el.css("width")
    @css.pLeft = @$el.css("paddingLeft")
    @css.left = @$el.css("left")
    @css.zIndex = @$el.css("zIndex")
    @$el.css(
      width: "98%"
      padding: 0
      left: 0
      zIndex: 19
    )
  mouseleave: ()->
    @$el.css(
      width: @css.width
      paddingLeft: @css.pLeft
      left: @css.left
      zIndex: @css.zIndex
    )