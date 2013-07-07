Gandalf.Views.Feed ||= {}

# A Feed is any view that has a calendar, a calendar nav and possibly an
# events list. This includes all the default views for #/:date/:type.
class Gandalf.Views.Feed.Index extends Backbone.View

  # options has keys [eventCollection, startDate, type]
  initialize: ->
    @eventCollection = @options.eventCollection
    @render()

  # When the calender is rendered full-width across the page
  fullWidthTemplate: JST["backbone/templates/feed/full_width"]
  panelTemplate: JST["backbone/templates/feed/panel"]
  el: "#content"

  render: ->
    if @options.type is 'list'
      @$el.html(@panelTemplate
        user: Gandalf.currentUser
        startDate: @options.startDate
      )
      firstEvent = @eventCollection.first()
      firstEventView = new Gandalf.Views.Feed.Event(model: firstEvent)
      @$(".main-event").html(firstEventView.el)
      # Add the event list
      eventList = new Gandalf.Views.EventList 
        eventCollection: @eventCollection
      @$(".body-feed").html(eventList.el)
    else 
      @$el.html(@fullWidthTemplate
        user: Gandalf.currentUser
        startDate: @options.startDate
      )
    Gandalf.calendarHeight = $(".content-calendar").height()

    # Add the nav.
    nav = new Gandalf.Views.CalendarNav
      type: @options.type
      startDate: @options.startDate
      root: ""

    @$(".content-calendar-nav > .container").html(nav.el)
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
