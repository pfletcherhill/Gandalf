Gandalf.Views.Events ||= {}

class Gandalf.Views.Events.CalendarWeekMultiday extends Backbone.View

  initialize: ()->
    @color = "rgba(#{@model.get("color")},1)"
    @lightColor = "rgba(#{@model.get("color")},0.7)"
    @eventId = @model.get("eventId")
    @startDate = @options.startDate.sod() 
    @render()

    Gandalf.dispatcher.on("feedEvent:mouseenter", @mouseenter, this)
    Gandalf.dispatcher.on("feedEvent:mouseleave", @mouseleave, this)
    Gandalf.dispatcher.on("feedEvent:click", @click, this)


  template: JST["backbone/templates/calendar/calendar_week_multiday"]
  className: "js-event cal-multiday-event"

  events:
    "click" : "click"
    "mouseenter" : "mouseenter"
    "mouseleave" : "mouseleave"

  render: () ->
    start = @model.get("start_at")
    end = @model.get("end_at")
    if moment(start) < @startDate
      startDay = 0
      start = @startDate
      @model.set calStart: start.format()    # So popover renders correctly
    else
      startDay = moment(start).day()
    @left = startDay* 14.2857

    diff = moment(end).diff(moment(start), 'days')
    if startDay + diff > 6
      endDay = 6
    else
      endDay = moment(end).day()
    @width = Math.floor((endDay - startDay + 1) * 14.2)

    @$el
      .html(@template(e: @model))
      .css(
        backgroundColor: @lightColor
        border: "1pt solid #{@color}"
        width: @width+"%"
        marginLeft: @left+"%"
      ).attr(
        "data-event-id": @model.get("id")
        "data-organization-id" : @model.get("organization_id")
        "data-category-ids" : @model.makeCatIdString()
      )

  # Event handlers

  click: (id) ->
    return if typeof id is "number" and @eventId isnt id
    Gandalf.dispatcher.trigger("event:click", { model: @model, color: @lightColor })

  mouseenter: (id) ->
    return if typeof id is "number" and @eventId isnt id
    @$el.css(
      backgroundColor: @color
      border: "1pt solid #333"
    )

  mouseleave: (id) ->
    return if typeof id is "number" and @eventId isnt id
    @$el.css(
      backgroundColor: @lightColor
      border: "1pt solid #{@color}"
    )
