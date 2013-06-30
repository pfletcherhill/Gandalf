Gandalf.Views.Calendar.Expanded ||= {}

class Gandalf.Views.Calendar.Expanded.Index extends Backbone.View
  initialize: ()->
    @eventCollection = @options.eventCollection
    @eventCollection.splitMultiday(false)        # Adjust multi-day events
    @days = @eventCollection.group()
    @startDate = @options.startDate
    @numDays = @options.numDays
    @render()
    Gandalf.dispatcher.on("multiday:show", @showMultiday, this)
    Gandalf.dispatcher.on("multiday:hide", @hideMultiday, this)

  template: JST["backbone/templates/calendar/expanded/index"]
  headerTemplate: JST["backbone/templates/calendar/expanded/header"]
  
  tagName: "div"
  className: "cal cal-week"

  addDay: (events, dayNum, date) ->
    view = new Gandalf.Views.Calendar.Expanded.Day
      model: events
      date: date
      dayNum: dayNum
      eventCollection: @eventCollection # Passing in event collection
    @$(".cal-day-container").append(view.el)
    return view
  
  render: () ->
    @$el.html(@template(startDate: moment(@startDate)))
    tempDate = moment(@startDate)
    dayCount = 0
    while dayCount < @numDays
      # Gandalf.eventKeyFormat was set when the app was initialized
      d = tempDate.format(Gandalf.eventKeyFormat)
      @addDay(@days[d], dayCount, moment(tempDate))
      tempDate.add('d', 1)
      dayCount++
    @renderMultidayEvents()
    return this

  renderMultidayEvents: ->
    events = @eventCollection.getMultidayEvents()
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



