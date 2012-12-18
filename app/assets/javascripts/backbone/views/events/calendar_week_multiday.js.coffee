Gandalf.Views.Events ||= {}

class Gandalf.Views.Events.CalendarWeekMultiday extends Backbone.View

  initialize: ()->
    @color = "rgba(#{@model.get("color")},1)"
    @lightColor = "rgba(#{@model.get("color")},0.7)"
    @eventId = @model.get("eventId")
    @startDate = @options.startDate.sod() 
    # Gandalf.dispatcher.on("feedEvent:mouseenter", @mouseenter, this)
    # Gandalf.dispatcher.on("feedEvent:mouseleave", @mouseleave, this)
    # Gandalf.dispatcher.on("feedEvent:click", @feedClick, this)
    @render()


  template: JST["backbone/templates/calendar/calendar_week_multiday"]
  className: "cal-multiday-event"

  events:
    "click" : "click"
    "mouseenter" : "mouseenter"
    "mouseleave" : "mouseleave"

  render: () ->
    start = @model.get("calStart")
    end = @model.get("calEnd")
    if moment(start) < @startDate
      startDay = 0
      start = @startDate
      @model.set calStart: start.format()    # So popover renders correctly
    else
      startDay = moment(start).day()
    @left = startDay* 14.2857

    diff = moment(end).diff(moment(start), 'days')
    console.log start, startDay, diff
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
      )

  # Event handlers

  click: () ->
    Gandalf.dispatcher.trigger("event:click", { model: @model, color: @lightColor })

  mouseenter: () ->
    @$el.css(
      backgroundColor: @color
      border: "1pt solid #333"
    )

  mouseleave: () ->
    @$el.css(
      backgroundColor: @lightColor
      border: "1pt solid #{@color}"
    )
