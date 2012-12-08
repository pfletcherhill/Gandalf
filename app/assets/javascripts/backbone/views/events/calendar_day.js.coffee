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
      for e in @model
        if not e.get("multiday")
          container = $(@el).children(".cal-events:first")
          if @options.type == "week"
            view = new Gandalf.Views.Events.CalendarWeekEvent(model: e) 
          else if @options.type == "month"
            view = new Gandalf.Views.Events.CalendarMonthEvent(model: e) 
          $(container).append(view.el)
      Gandalf.dispatcher.trigger("calEvents:ready")

  render: () ->
    $(@el).html(@template(date: @options.date)) # Add the calendar day
    @addEvents()
    return this
