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
        continued = e.get("start_at") isnt e.get("calStart")
        continues = e.get("end_at") isnt e.get("calEnd")
        if continues or continued # Multiday event
          view = new Gandalf.Views.Calendar.Month.Event(
            model: e
            continued: continued
            continues: continues
            calEvents: @options.calEvents
          ) 
          $(container).append(view.el)
      for e in @model
        continued = e.get("start_at") isnt e.get("calStart")
        continues = e.get("end_at") isnt e.get("calEnd")
        if not (continues or continued) # Not a multiday event
          view = new Gandalf.Views.Calendar.Month.Event(model: e) 
          $(container).append(view.el)

  render: () ->
    @$el.html(@template(date: @date)) # Add the calendar day
    if @date.date() is moment().date() and @date.month() is moment().month() and @date.year() is moment().year()
      @$el.addClass "today"
    @addEvents()
    return this
