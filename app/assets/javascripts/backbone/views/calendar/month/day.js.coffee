Gandalf.Views.Calendar.Month ||= {}

class Gandalf.Views.Calendar.Month.Day extends Backbone.View

  initialize: ->
    @date = @options.date
    @render()

  tagName: "td"
  className: "cal-day"
  template: JST["backbone/templates/calendar/month/day"]

  addEvents: () ->
    if @model
      container = @$el.children(".cal-events:first")
      for e in @model
        view = new Gandalf.Views.Calendar.Month.Event(model: e) 
        $(container).append(view.el)
      Gandalf.dispatcher.trigger("calEvents:ready")

  render: () ->
    @$el.html(@template(date: @date)) # Add the calendar day
    if @date.date() is moment().date() and @date.month() is moment().month() and @date.year() is moment().year()
      @$el.addClass "today"
    @addEvents()
    return this
