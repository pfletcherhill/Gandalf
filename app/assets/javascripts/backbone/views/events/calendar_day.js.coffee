Gandalf.Views.Events ||= {}

class Gandalf.Views.Events.CalendarDay extends Backbone.View

  initialize: ->
    switch @options.type
      when "week" then @template = JST["backbone/templates/calendar/calendar_week_day"]
      when "month" then @template = JST["backbone/templates/calendar/calendar_month_day"]
      when "blank" then @template = JST["backbone/templates/calendar/calendar_blank_day"]
    @render()

  tagName: "td"
  className: "cal-day"

  addEvents: () ->
    if @model
      container = $(@el).children(".cal-events:first")
      for e in @model
        view = new Gandalf.Views.Events.CalendarWeekEvent(model: e) if @options.type == "week"
        view = new Gandalf.Views.Events.CalendarMonthEvent(model: e) if @options.type == "month"
        $(container).append(view.el)
      Gandalf.dispatcher.trigger("calEvents:ready")

  render: () ->
    $(@el).html(@template()) # Add the calendar day
    @addEvents()
    

    return this
