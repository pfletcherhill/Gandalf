Gandalf.Views.Events ||= {}

class Gandalf.Views.Events.CalendarWeek extends Backbone.View
  initialize: ()->
    @days = @options.days
    @startDate = @options.startDate
    @render()
    Gandalf.dispatcher.on("popovers:hide", @hidePopovers)

  template: JST["backbone/templates/calendar/calendar_week"]
  headerTemplate: JST["backbone/templates/calendar/calendar_week_header"]
  
  tagName: "div"
  className: "cal cal-week"

  events:
    "click .hour-day" : "hidePopovers"

  addCalDay: (events) ->
    view = new Gandalf.Views.Events.CalendarDay(model: events, type: "week")
    @$(".cal-day-container").append(view.el)
  
  render: () ->
    @$el.html(@headerTemplate(startDate: moment(@startDate)))
    $(@el).append(@template())
    tempDate = moment(@startDate)
    dayCount = 0
    while dayCount < 7
      # Gandalf.eventKeyFormat was set when the app was initialized
      d = tempDate.add('d', 1).format(Gandalf.eventKeyFormat)
      @addCalDay(@days[d])
      dayCount++
    return this


  hidePopovers: () ->
    $("[rel='event-popover']").popover("hide")