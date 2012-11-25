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
    Gandalf.dispatcher.on("feedEvent:feedmouseenter", @mouseenter)
    Gandalf.dispatcher.on("feedEvent:feedmouseleave", @mouseleave)
    Gandalf.dispatcher.on("feedEvent:click", @feedClick)
    Gandalf.dispatcher.on("eventVisibility:change", @visibilityChange)


  template: JST["backbone/templates/events/calendar_event"]
  popoverTemplate: JST["backbone/templates/events/calendar_popover"]

  tagName: "div"
  className: "cal-event"
  attributes: 
    rel: "event-popover"
  popoverChild: ".event-name:first"

  events:
    "click": "onClick"
    "mouseenter" : "mouseenter"
    "mouseleave" : "mouseleave"

  render: () ->
    $(@el).html(@template( event: @model ))
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

  visibilityChange: (obj) ->
    time = 200
    # User event-hidden-org and event-hidden-cat because of the case when
    # if an event is hidden by both an organization and a category
    # TO DO: what if it's hidden by multiple categories?
    if obj.kind is "organization"
      if parseInt(@$el.attr("data-organization-id")) is obj.id
        if obj.state is "show"
          @$el.removeClass("event-hidden-org")
        else
          @$el.addClass("event-hidden-org")
    if obj.kind is"category"
      if @$el.attr("data-category-ids").indexOf(obj.id+",") isnt -1
        if obj.state is "show"
          @$el.removeClass("event-hidden-cat")
        else
          @$el.addClass("event-hidden-cat")