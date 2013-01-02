Gandalf.Views.Calendar ||= {}

class Gandalf.Views.Calendar.Day extends Backbone.View

  initialize: ->
    switch @options.type
      when "week" then @template = JST["backbone/templates/calendar/week/day"]
      when "month" then @template = JST["backbone/templates/calendar/month/day"]
    @date = @options.date
    @hourHeight = Gandalf.calendarHeight / 24.0
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
    @$el.html(@template(date: @date)) # Add the calendar day
    if @date.date() is moment().date() and @date.month() is moment().month() and @date.year() is moment().year()
      @$el.addClass "today"
      @$el.append("<div id='time-marker'><img id='time-marker-img' src='/assets/y_logo_200.png' /></div>")
      @nowMarker()
      setInterval @nowMarker, 15*60*1000
    @addEvents()
    return this

  nowMarker: ->
    top = @getNowPosition()
    console.log top
    @$el.find("#time-marker").css(top: "#{top}px")

  getNowPosition: ->
    t = moment()
    hours = t.hours() + t.minutes()/60
    return Math.floor(hours*@hourHeight)
