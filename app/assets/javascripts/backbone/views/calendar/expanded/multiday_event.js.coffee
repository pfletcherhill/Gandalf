Gandalf.Views.Calendar.Expanded ||= {}

class Gandalf.Views.Calendar.Expanded.MultidayEvent extends Backbone.View

  initialize: ()->
    @color = "rgba(#{@model.get("color")},1)"
    @lightColor = "rgba(#{@model.get("color")},0.7)"
    @hourHeight = Gandalf.calendarHeight / 24.0
    @eventId = @model.get("eventId")
    @num = @options.eventNum
    @numDays = @options.numDays
    @startDate = @options.startDate.sod() 
    @render()

    Gandalf.dispatcher.on("feed:event:mouseenter", @mouseenter, this)
    Gandalf.dispatcher.on("feed:event:mouseleave", @mouseleave, this)
    Gandalf.dispatcher.on("feed:event:click", @click, this)
    this


  template: JST["backbone/templates/calendar/expanded/multiday_event"]
  className: "js-event cal-multiday-event arrow_box"

  events:
    "click" : "click"
    "mouseenter" : "mouseenter"
    "mouseleave" : "mouseleave"

  render: () ->
    console.log @model
    modelStart = moment(@model.get("start_at"))
    modelEnd = moment(@model.get("end_at"))
    continued = continues = false
    if modelStart < @startDate
      startDay = 0
      # modelStart = @startDate # Just for rendern
      continued = true
      # @model.set calStart: start.format()    # So popover renders correctly
    else
      startDay = modelStart.day()
    @left = startDay * (100 / @numDays)

    diff = modelEnd.diff(modelStart, 'days')
    if startDay + diff > @numDays - 1
      endDay = @numDays - 1
      continues = true
    else
      endDay = moment(end).day()

    @width = (endDay - startDay + 1) * (98/@numDays) # 14.2

    @$el
      .html(@template
        e: @model
        continued: continued
        continues: continues
      ).css(
        backgroundColor: @lightColor
        # border: "1pt solid #{@color}"
        width: @width+"%"
        left: @left+"%"
        # top: "#{(@num+3)*@hourHeight}px"
      ).attr(
        "data-event-id": @model.get("id")
        "data-organization-id" : @model.get("organization_id")
        "data-category-ids" : @model.makeCatIdString()
      )
    this

  # Event handlers

  click: (id) ->
    return if typeof id is "number" and @eventId isnt id
    Gandalf.dispatcher.trigger("event:click", { model: @model, color: @lightColor })

  mouseenter: (id) ->
    return if typeof id is "number" and @eventId isnt id
    @$el.css(
      backgroundColor: @color
    )

  mouseleave: (id) ->
    return if typeof id is "number" and @eventId isnt id
    @$el.css(
      backgroundColor: @lightColor
    )
