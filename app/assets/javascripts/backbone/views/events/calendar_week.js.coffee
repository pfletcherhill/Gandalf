Gandalf.Views.Events ||= {}

class Gandalf.Views.Events.CalendarWeek extends Backbone.View
  initialize: ()->
    @days = @options.days
    @startDate = @options.startDate
    
    Gandalf.dispatcher.on("popovers:hide", @hidePopovers)
    Gandalf.dispatcher.on("weekEvent:multiday", @multiday, this)

    @render()

  template: JST["backbone/templates/calendar/calendar_week"]
  headerTemplate: JST["backbone/templates/calendar/calendar_week_header"]
  
  tagName: "div"
  className: "cal cal-week"

  events:
    "click .hour-day" : "hidePopovers"

  addCalDay: (events, dayNum) ->
    view = new Gandalf.Views.Events.CalendarDay(model: events, type: "week", dayNum: dayNum)
    @$(".cal-day-container").append(view.el)
  
  render: () ->
    @$el.html(@headerTemplate(startDate: moment(@startDate)))
    $(@el).append(@template())
    tempDate = moment(@startDate)
    dayCount = 0
    while dayCount < 7
      # Gandalf.eventKeyFormat was set when the app was initialized
      d = tempDate.format(Gandalf.eventKeyFormat)
      @addCalDay(@days[d], dayCount)
      tempDate.add('d', 1)
      dayCount++
    return this

  # Event handlers

  hidePopovers: () ->
    $("[rel='event-popover']").popover("hide")

  multiday: (text) ->
    console.log @$el.find(".cal-multiday")
    @$el.children(".cal-multiday").html(text)
