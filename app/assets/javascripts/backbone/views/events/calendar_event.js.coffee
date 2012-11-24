Gandalf.Views.Events ||= {}

class Gandalf.Views.Events.CalendarEvent extends Backbone.View

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
    Gandalf.dispatcher.on("feedEvent:feedmouseenter", @mouseenter)
    Gandalf.dispatcher.on("feedEvent:feedmouseleave", @mouseleave)
    Gandalf.dispatcher.on("feedEvent:click", @feedClick)
    Gandalf.dispatcher.on("eventVisibility:change", @visibilityChange)


  template: JST["backbone/templates/events/calendar_event"]
  popoverTemplate: JST["backbone/templates/events/calendar_popover"]

  # This element is an li so that :nth-of-type works properly in the CSS
  tagName: "div"
  className: "cal-event"
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
    style_string = "top: "+@top+"px; height: "+@height+"px;"
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
    container = @$el.parents("#calendar-container")
    if @height > 300
      scrolltop = @top + 100
    else
      middle = @top + @height / 2
      scrolltop = middle - 250
    $(container).animate scrollTop: scrolltop, 300


  popover: () ->
    id = @model.get("id")
    # Hide all other popovers
    otherPopovers = $("[rel='event-popover']:not([data-event-id='"+id+"'])")
    otherPopovers.popover('hide') if otherPopovers
    # Add event handler to close button
    t = this
    $(".popover .close").click (e) ->
      t.$el.popover('hide')

  feedmouseenter: (id) ->
    if !id || @model.get("id") == id
      @$el.css(
        backgroundColor: "rgba(170,170,170,0.9)"
        zIndex: 15
      )

  feedmouseleave: (id) ->
    if !id || @model.get("id") == id
      @$el.css(
        backgroundColor: @css.backgroundColor
        zIndex: @css.zIndex
      )

  feedClick:(id) ->
    if !id || @model.get("id") == id
      @$el.click()

  visibilityChange: (obj) ->
    time = 200
    if obj.kind == "organization"
      if parseInt(@$el.attr("data-organization-id")) == obj.id
        if obj.state == "show"
          @$el.removeClass("event-hidden")
        else if obj.state == "hide"
          @$el.addClass("event-hidden")
    if obj.kind == "category"
      if @$el.attr("data-category-ids").indexOf(obj.id+",") != -1
        if obj.state == "show"
          @$el.removeClass("event-hidden")
        else if obj.state == "hide"
          @$el.addClass("event-hidden")
    # Tells index to readjust the overlapping events
    Gandalf.dispatcher.trigger("index:adjust")

  mouseenter:() ->
    
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


