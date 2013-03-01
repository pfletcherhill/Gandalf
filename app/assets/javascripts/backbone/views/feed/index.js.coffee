Gandalf.Views.Feed ||= {}

class Gandalf.Views.Feed.Index extends Backbone.View

  # options has keys [events, startDate, period]
  initialize: ()->
    _.bindAll(this, 
      "renderSubscribedOrganizations",
      "renderSubscribedCategories"
    )
    @multidayVisible = true
    @render()

    # Render AJAX info
    Gandalf.currentUser.fetchSubscribedOrganizations().then @renderSubscribedOrganizations
    Gandalf.currentUser.fetchSubscribedCategories().then @renderSubscribedCategories

  template: JST["backbone/templates/feed/index"]

  el: "#content"

  events:
    "click .toggle-multiday" : "toggleMultiday"

  # Rendering functions

  # renderMonthMenu: (period, startDate) ->
  #   today = moment(startDate).day(6).date(1)
  #   prev = moment(thisMonth).subtract('M', 1).format(Gandalf.displayFormat)
  #   next = moment(thisMonth).add('M', 1).format(Gandalf.displayFormat)
  #   if moment().month() == thisMonth.month()
  #     other = 'today'
  #   else
  #     other = moment(startDate).format(Gandalf.displayFormat)
  #   # Add to html
  #   @$(".cal-nav span").html thisMonth.format("MMMM YYYY")
  #   @$(".cal-nav .previous").attr 'href', '#calendar/' + prevMonth + '/month'
  #   @$(".cal-nav .next").attr 'href', '#calendar/' + nextMonth + '/month'
  #   @$(".cal-nav .week").attr 'href', '#calendar/' + weekDate + '/week'
  #   @$(".cal-nav .month").addClass 'disabled'

  # renderWeekMenu: (period, startDate) ->
  #   if moment().day(1).format("DD") == moment(startDate).day(1).format("DD")
  #     month = moment().date(1).format(Gandalf.displayFormat)
  #   else
  #     month = moment(startDate).date(1).format(Gandalf.displayFormat)
  #   prevWeek = moment(startDate).subtract('w', 1).format(Gandalf.displayFormat)
  #   nextWeek = moment(startDate).add('w', 1).format(Gandalf.displayFormat)
  #   endDate = moment(startDate).add('d', 6)
  #   # Add to html
  #   @$(".cal-nav span").html startDate.format("MMM D") + " - " + endDate.format("MMM D") + ", " + endDate.format("YYYY")
  #   @$(".cal-nav .previous").attr 'href', '#calendar/' + prevWeek + '/week'
  #   @$(".cal-nav .next").attr 'href', '#calendar/' + nextWeek + '/week'
  #   @$(".cal-nav .week").addClass 'disabled'
  #   @$(".cal-nav .month").attr 'href', '#calendar/' + month + '/month'
      
  renderFeed: () ->
    noEvents = "<div class='feed-notice'>You aren't subcribed to any events for this period...</div>"
    @$(".body-feed").append(noEvents) if _.isEmpty(@days)
    @doneEvents = []
    for day, events of @days
      @addFeedDay(day, events)

  addFeedDay: (day, events) ->
    view = new Gandalf.Views.Feed.Day(day: day, collection: events, done: @doneEvents)
    @$(".body-feed").append(view.el)

  renderSubscribedOrganizations: ->
    subscriptions = Gandalf.currentUser.get('subscribed_organizations')
    hidden = @options.events.getHiddenOrgs()
    # for s in subscriptions
    #       invisible = false
    #       invisible = true if s.id in hidden
    #       view = new Gandalf.Views.Organizations.Short(model: s, invisible: invisible)
    #       $("#subscribed-organizations-list").append(view.el)
  
  renderSubscribedCategories: ->
    subscriptions = Gandalf.currentUser.get('subscribed_categories')
    hidden = @options.events.getHiddenCats()
    # for s in subscriptions
    #       invisible = false
    #       invisible = true if s.id in hidden
    #       view = new Gandalf.Views.Categories.Short(model: s, invisible: invisible)
    #       $("#subscribed-categories-list").append(view.el)


  render: () ->
    @$el.html(@template({ user: Gandalf.currentUser, startDate: @options.startDate }))
    Gandalf.calendarHeight = $(".content-calendar").height()
    @days = @options.events.group()
    view = new Gandalf.Views.CalendarNav(
      period: @options.period
      startDate: @options.startDate
      root: "calendar"
    )
    @$(".content-cal-nav").html(view.el)
    
    @renderFeed()
    $("[rel=tooltip]").tooltip()
    view = new Gandalf.Views.Calendar.Index(
      type: @options.period
      events: @options.events
      startDate: @options.startDate
    )
    $(".content-calendar").html(view.el)
    return this

  # Event handlers

  toggleMultiday: ->
    @$(".toggle-multiday > i")
      .toggleClass("icon-eye-close")
      .toggleClass("icon-eye-open")
    if @multidayVisible
      Gandalf.dispatcher.trigger("multiday:hide")
    else
      Gandalf.dispatcher.trigger("multiday:show")
    @multidayVisible = not @multidayVisible
    console.log "hi"