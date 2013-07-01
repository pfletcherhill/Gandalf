Gandalf.Views.Calendar.Expanded ||= {}

class Gandalf.Views.Calendar.Expanded.Index extends Backbone.View
  initialize: ()->
    @eventCollection = @options.eventCollection
    @eventCollection.splitMultiday(false)        # Adjust multi-day events
    @days = @eventCollection.group()
    @numDays = @options.numDays
    @startDate = @options.startDate
    @endDate = moment(@startDate).add('d', @numDays)
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
      # Make sure event is actually on the calendar (for list view).
      if moment(e.get('start_at')) < @endDate and moment(e.get('end_at')) > @startDate
        view = new Gandalf.Views.Calendar.Expanded.MultidayEvent
          model: e
          startDate: moment(@startDate)
          eventNum: eNum
          numDays: @numDays # Number of total days being rendered.

        @$(".cal-multiday").append(view.el) if view.el
        eNum++

  showMultiday: ->
    $(".cal-multiday").removeClass "hidden"

  hideMultiday: ->
    $(".cal-multiday").addClass "hidden"



