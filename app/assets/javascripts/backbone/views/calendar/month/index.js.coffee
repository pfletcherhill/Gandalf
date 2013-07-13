Gandalf.Views.Calendar.Month ||= {}

class Gandalf.Views.Calendar.Month.Indsex extends Backbone.View
  initialize: ()->
    @calEvents = @options.calEvents
    @calEvents.splitMultiday(true)        # Adjust multi-day events
    @days = @calEvents.group()
    @startDate = @options.startDate
    @render()

  template: JST["backbone/templates/calendar/month/index"]
  headerTemplate: JST["backbone/templates/calendar/month/header"]
  
  tagName: "div"
  className: "cal cal-month"

  addWeeks: () ->
    tempDate = moment(@startDate)
    dayCount = 0
    while dayCount < 35
      if dayCount%7 is 0
        @$(".cal-table").append("<tr class='cal-day-container'></tr>")
      # Gandalf.eventKeyFormat was set when the app was initialized
      d = tempDate.format(Gandalf.eventKeyFormat)
      @addDay(@days[d], moment(tempDate))
      tempDate.add('d', 1)
      dayCount++

  addDay: (events, date) ->
    view = new Gandalf.Views.Calendar.Month.Day(
      model: events
      date: date
      calEvents: @calEvents # Passing in event collection
    )
    @$(".cal-day-container:last").append(view.el)
  
  render: () ->
    @$el.html(@template(startDate: moment(@startDate)))
    @addWeeks()
    return this
