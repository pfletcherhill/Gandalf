Gandalf.Views.Events ||= {}

class Gandalf.Views.Events.CalendarMonthEvent extends Backbone.View

  initialize: ()->
    @render()
    @$el.popover(
      placement: 'top'
      html: true
      trigger: 'click'
      content: @popoverTemplate(e: @model)
    )
    @css = {}
    @css.backgroundColor = @$el.css("backgroundColor")
    @css.zIndex = @$el.css("zIndex")
    # Yet to be done for month
    Gandalf.dispatcher.on("feedEvent:mouseenter", @feedmouseenter)
    Gandalf.dispatcher.on("feedEvent:mouseleave", @feedmouseleave)
    Gandalf.dispatcher.on("feedEvent:click", @feedClick)

  template: JST["backbone/templates/calendar/calendar_month_event"]
  popoverTemplate: JST["backbone/templates/calendar/calendar_popover"]

  tagName: "div"
  className: "js-event cal-event cal-month-event"
  attributes: 
    rel: "event-popover"
  popoverChild: ".event-name:first"

  # events:
  #   "click": "onClick"
  #   "mouseenter" : "mouseenter"
  #   "mouseleave" : "mouseleave"

  render: () ->
    $(@el).html(@template( event: @model ))
    return this

  onClick: () ->
    @scroll()
    @popover()

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