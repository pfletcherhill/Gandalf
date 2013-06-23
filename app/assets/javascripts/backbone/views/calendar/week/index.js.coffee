Gandalf.Views.Calendar.Week ||= {}

class Gandalf.Views.Calendar.Week.Index extends Backbone.View
  initialize: ()->
    @calEvents = @options.calEvents
    @calEvents.splitMultiday(false)        # Adjust multi-day events
    @days = @calEvents.group()
    @startDate = @options.startDate
    @render()
    Gandalf.dispatcher.on("multiday:show", @showMultiday, this)
    Gandalf.dispatcher.on("multiday:hide", @hideMultiday, this)

  template: JST["backbone/templates/calendar/week/index"]
  headerTemplate: JST["backbone/templates/calendar/week/header"]
  
  tagName: "div"
  className: "cal cal-week"

  addDay: (events, dayNum, date) ->
    view = new Gandalf.Views.Calendar.Week.Day(
      model: events
      date: date
      dayNum: dayNum
      calEvents: @calEvents # Passing in event collection
    )
    @$(".cal-day-container").append(view.el)
    return view
  
  render: () ->
    @$el.html(@template(startDate: moment(@startDate)))
    tempDate = moment(@startDate)
    dayCount = 0
    while dayCount < 7
      # Gandalf.eventKeyFormat was set when the app was initialized
      d = tempDate.format(Gandalf.eventKeyFormat)
      @addDay(@days[d], dayCount, moment(tempDate))
      tempDate.add('d', 1)
      dayCount++
    @renderMultidayEvents()
    return this

  renderMultidayEvents: ->
    events = @calEvents.getMultidayEvents()
    eNum = 0
    for e in events
      view = new Gandalf.Views.Calendar.Week.MultidayEvent(
        model: e
        startDate: moment(@startDate)
        eventNum: eNum
      )
      @$(".cal-multiday").append(view.el)
      eNum++

  showMultiday: ->
    $(".cal-multiday").removeClass "hidden"

  hideMultiday: ->
    $(".cal-multiday").addClass "hidden"



