Gandalf.Views.Calendar ||= {}

class Gandalf.Views.Calendar.Day extends Backbone.View

  initialize: ->
    switch @options.type
      when "week" then @template = JST["backbone/templates/calendar/calendar_week_day"]
      when "month" then @template = JST["backbone/templates/calendar/calendar_month_day"]
    @render()

  tagName: "td"
  className: "cal-day"

  addEvents: () ->
    if @model
      for e in @model
        container = $(@el).children(".cal-events:first")
        if @options.type is "week" and not e.get("multiday")
          view = new Gandalf.Views.Calendar.Week.Event(model: e, dayNum: @options.dayNum) 
        else if @options.type is "month"
          view = new Gandalf.Views.Calendar.Month.Event(model: e) 
        $(container).append(view.el)
      Gandalf.dispatcher.trigger("calEvents:ready")

  render: () ->
    $(@el).html(@template(date: @options.date)) # Add the calendar day
    @addEvents()
    return this