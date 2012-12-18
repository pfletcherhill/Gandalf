Gandalf.Views.Events ||= {}

class Gandalf.Views.Events.CalendarMonthEvent extends Backbone.View

  initialize: ()->
    @color = "rgba(#{@model.get("color")},1)"
    @lightColor = "rgba(#{@model.get("color")},0.7)"
    @continued = (@model.get("start_at") isnt @model.get("calStart"))
    @continues = (@model.get("end_at") isnt @model.get("calEnd"))
    @render()
    # Yet to be done for month
    Gandalf.dispatcher.on("feedEvent:mouseenter", @mouseenter, this)
    Gandalf.dispatcher.on("feedEvent:mouseleave", @mouseleave, this)
    Gandalf.dispatcher.on("feedEvent:click", @feedClick, this)

  template: JST["backbone/templates/calendar/calendar_month_event"]
  popoverTemplate: JST["backbone/templates/calendar/calendar_popover"]

  tagName: "div"
  className: "js-event cal-event cal-month-event"
  attributes: 
    rel: "event-popover"
  popoverChild: ".event-name:first"

  events:
    "click": "onClick"
    "mouseenter" : "mouseenter"
    "mouseleave" : "mouseleave"

  render: () ->
    if @continued or @continues
      $(@el).css(
        color: "#222"
        backgroundColor: @lightColor
        width: "100%"
      )
    else
      $(@el).css(
        color: @lightColor
      )

    @$el.html(@template({ event: @model, continued: @continued }))
    return this

  onClick: () ->
    Gandalf.dispatcher.trigger("event:click", 
      { model: @model, color: @lightColor })

  ###
  scroll:() ->
    tHeight = 300 # popover height
    padTop = 50   # space above popover when scrolling to
    container = @$el.parents(".cal-body")
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
  ###
  mouseenter: (id) ->
    return if typeof id is "number" and @model.get("id") isnt id
    if @continues or @continued
      @$el.css({ backgroundColor: @color })
    else
      @$el.css({ color: @color })

  mouseleave: (id) ->
    return if typeof id is "number" and @model.get("id") isnt id
    if @continues or @continued
      @$el.css({ backgroundColor: @lightColor })
    else
      @$el.css({ color: @lightColor })

  feedClick:(id) ->
    if not id or @model.get("id") is id
      @$el.click()