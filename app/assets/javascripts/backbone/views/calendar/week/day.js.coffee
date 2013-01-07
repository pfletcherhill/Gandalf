Gandalf.Views.Calendar.Week ||= {}

class Gandalf.Views.Calendar.Week.Day extends Backbone.View

  initialize: ->
    @date = @options.date
    @hourHeight = Gandalf.calendarHeight / 24.0
    @render()

  tagName: "td"
  className: "cal-day"
  template: JST["backbone/templates/calendar/week/day"]

  addEvents: () ->
    if @model
      container = @$el.children(".cal-events:first")
      for e in @model
        if not e.get("multiday")
          view = new Gandalf.Views.Calendar.Week.Event(model: e, dayNum: @options.dayNum) 
        $(container).append(view.el)
      Gandalf.dispatcher.trigger("calEvents:ready")

  render: () ->
    @$el.html(@template(date: @date)) # Add the calendar day
    if @date.date() is moment().date() and @date.month() is moment().month() and @date.year() is moment().year()
      @$el.addClass "today"
      @$el.append("<div id='time-marker'><img id='time-marker-img' src='/assets/y_logo_200.png' /></div>")
      @nowMarker()
      t = this
      setInterval( ->
        t.nowMarker()
      , 15*60*1000)
    @addEvents()
    return this

  nowMarker: ->
    top = @getNowPosition()
    @$el.find("#time-marker").css(top: "#{top}px")

  getNowPosition: ->
    t = moment()
    hours = t.hours() + t.minutes()/60
    return Math.floor(hours*@hourHeight)
