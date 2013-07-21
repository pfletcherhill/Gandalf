Gandalf.Views.Calendar.Compressed ||= {}

class Gandalf.Views.Calendar.Compressed.Event extends Backbone.View

  initialize: ()->
    @color = "rgba(#{@model.get("color")},1)"
    @lightColor = "rgba(#{@model.get("color")},0.7)"
    @continued = @options.continued
    @continues = @options.continues
    @eventId = @model.get("eventId")
    @render()
    Gandalf.dispatcher.on("feed:event:mouseenter", @mouseenter, this)
    Gandalf.dispatcher.on("feed:event:mouseleave", @mouseleave, this)
    Gandalf.dispatcher.on("feed:event:click", @click, this)

  template: JST["backbone/templates/calendar/month/event"]
  popoverTemplate: JST["backbone/templates/calendar/popover"]

  tagName: "div"
  className: "js-event cal-event cal-month-event"
  attributes: 
    rel: "event-popover"
  popoverChild: ".event-name:first"

  events:
    "click": "click"
    "mouseenter" : "mouseenter"
    "mouseleave" : "mouseleave"

  render: () ->
    if @continued or @continues
      @$el.css
        color: "#222"
        backgroundColor: @lightColor
        width: "100%"
    else
      @$el.css
        color: @lightColor

    @$el.attr(
      "data-event-id": @model.get("id")
      "data-organization-id" : @model.get("organization_id")
      "data-category-ids" : @model.makeCatIdString()
    ).html(@template({ event: @model, continued: @continued }))
    return this

  click: (id) ->
    return if typeof id is "number" and @eventId isnt id
    m = @model
    eId = m.get("eventId")
    if m.get("id") isnt eId
      m = @options.calEvents.get(eId)
    Gandalf.dispatcher.trigger("event:click", 
      { model: @model, color: @lightColor })

  mouseenter: (id) ->
    return if typeof id is "number" and @eventId isnt id
    if @continues or @continued
      @$el.css({ backgroundColor: @color })
    else
      @$el.css({ color: @color })

  mouseleave: (id) ->
    return if typeof id is "number" and @eventId isnt id
    if @continues or @continued
      @$el.css({ backgroundColor: @lightColor })
    else
      @$el.css({ color: @lightColor })

  # feedClick:(id) ->
  #   if not id or @model.get("id") is id
  #     @$el.click()
