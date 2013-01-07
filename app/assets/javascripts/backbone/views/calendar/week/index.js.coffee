Gandalf.Views.Calendar.Week ||= {}

class Gandalf.Views.Calendar.Week.Index extends Backbone.View
  initialize: ()->
    @days = @options.days
    @startDate = @options.startDate
    Gandalf.dispatcher.on("weekEvent:multiday", @multiday, this)
    @render()

  template: JST["backbone/templates/calendar/week/index"]
  headerTemplate: JST["backbone/templates/calendar/week/header"]
  
  tagName: "div"
  className: "cal cal-week"

  # events:
    # "click .global-overlay" : "hidePopover"

  addCalDay: (events, dayNum, date) ->
    view = new Gandalf.Views.Calendar.Week.Day(
      model: events,
      date: date,
      dayNum: dayNum
    )

    @$(".cal-day-container").append(view.el)
  
  render: () ->
    # @$el.html(@headerTemplate(startDate: moment(@startDate)))
    @$el.append(@template(startDate: moment(@startDate)))
    tempDate = moment(@startDate)
    dayCount = 0
    while dayCount < 7
      # Gandalf.eventKeyFormat was set when the app was initialized
      d = tempDate.format(Gandalf.eventKeyFormat)
      @addCalDay(@days[d], dayCount, moment(tempDate))
      tempDate.add('d', 1)
      dayCount++
    return this



