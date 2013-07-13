Gandalf.Views.Feed ||= {}

# A Feed is any view that has a calendar, a calendar nav and possibly an
# events list. This includes all the default views for #/:date/:type.
class Gandalf.Views.Feed.Index extends Backbone.View

  # @options should have keys [eventCollection, startDate, type]
  initialize: ->
    @eventCollection = @options.eventCollection
    @startDate = @options.startDate
    @render()

  # When the calender is rendered full-width across the page
  fullWidthTemplate: JST["backbone/templates/feed/full_width"]
  panelTemplate: JST["backbone/templates/feed/panel"]
  el: "#content"

  today: ->
    @startDate.format(Gandalf.displayFormat) is
      moment().format(Gandalf.displayFormat)

  makeHeaderText: ->
    startText = ""
    if @today()
      return "Up next for you"
    else if @startDate is moment().subtract('d', 1).format(Gandalf.displayFormat)
      startText = "Yesterday, "
    else if @startDate is moment().add('d', 1).format(Gandalf.displayFormat)
      startText = "Tomorrow, "
    return startText + @startDate.format("MMMM D, YYYY")

  render: ->
    if @options.type is 'list'
      @$el.html @panelTemplate
        user: Gandalf.currentUser
        startDate: @startDate
        headerText: @makeHeaderText()
      # If it's today, then try to show the "large" event.
      # Note if an event shouldn't be rendered in the feed.
      skippedEventId = null 
      if @today()
        upcomingEvents = @eventCollection.filter (e) ->
          return moment(e.get('start_at')) > moment()
        nextEvent = upcomingEvents[0]
        console.log 'first event', nextEvent, upcomingEvents
        if nextEvent
          skippedEventId = nextEvent.id
          nextEventView = new Gandalf.Views.Feed.Event(model: nextEvent)
          @$(".main-event").html(nextEventView.el)
      # Add the event list
      eventList = new Gandalf.Views.EventList 
        eventCollection: @eventCollection
        skippedEventId: skippedEventId
      console.log 'event col', @eventCollection
      @$(".body-feed").html(eventList.el)
    else 
      @$el.html(@fullWidthTemplate
        user: Gandalf.currentUser
        startDate: @options.startDate
      )
    # Not sure why this line is necessary but it is.
    Gandalf.calendarHeight = $(".content-calendar").height()

    # Add the nav.
    nav = new Gandalf.Views.CalendarNav
      type: @options.type
      startDate: @options.startDate
      root: ""
    @$(".content-calendar-nav").html(nav.el)

    # Add the calendar.
    cal = new Gandalf.Views.Calendar
      type: @options.type
      eventCollection: @eventCollection
      startDate: @options.startDate
    @$(".content-calendar").html(cal.el)
    
    # Activate tooltips on the page.
    $("[rel=tooltip]").tooltip(
      placement: 'right'
    )
    return this
