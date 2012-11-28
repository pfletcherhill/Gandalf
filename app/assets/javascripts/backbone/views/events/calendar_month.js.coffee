Gandalf.Views.Events ||= {}

class Gandalf.Views.Events.CalendarMonth extends Backbone.View
  initialize: ()->
    @days = @options.days
    @startDate = @options.startDate
    @render()
    Gandalf.dispatcher.on("popovers:hide", @hidePopovers)

  template: JST["backbone/templates/calendar/calendar_month"]
  headerTemplate: JST["backbone/templates/calendar/calendar_month_header"]
  
  tagName: "div"
  className: "cal cal-month"

  addWeeks: () ->
    tempDate = moment(@startDate)
    dayCount = 0
    while dayCount < 35
      if dayCount%7 is 0
        @$(".cal-body-table").append("<tr class='cal-day-container'></tr>")
      # Gandalf.eventKeyFormat was set when the app was initialized
      d = tempDate.add('d', 1).format(Gandalf.eventKeyFormat)
      @addDay(@days[d], moment(tempDate))
      dayCount++

  addDay: (events, date) ->
    view = new Gandalf.Views.Events.CalendarDay(
      model: events, type: "month", date: date
    )
    @$(".cal-day-container:last").append(view.el)
  
  render: () ->
    @$el.html(@headerTemplate(startDate: moment(@startDate)))
    @$el.append(@template())
    @addWeeks()
    return this

  hidePopovers: () ->
    $("[rel='event-popover']").popover("hide")