Gandalf.Views.Feed ||= {}

class Gandalf.Views.Feed.Index extends Backbone.View

  # options has keys [events, startDate, period]
  initialize: ()->
    _.bindAll(this,
      "renderSubscribedOrganizations",
      "renderSubscribedCategories"
    )
    @render()

  template: JST["backbone/templates/feed/index"]

  el: "#content"

  # Rendering functions

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
    console.log "rendering subscribed Organizations"
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
    # @days = @options.events.group()
    # @renderFeed()
    eventList = new Gandalf.Views.EventList (
      events: @options.events
    )
    @$(".body-feed").html(eventList.el)
    nav = new Gandalf.Views.CalendarNav(
      period: @options.period
      startDate: @options.startDate
      root: "calendar"
    )
    @$(".content-calendar-nav > .container").html(nav.el)
    cal = new Gandalf.Views.Calendar.Index(
      type: @options.period
      events: @options.events
      startDate: @options.startDate
    )
    $(".content-calendar").html(cal.el)
    
    $("[rel=tooltip]").tooltip(
      placement: 'right'
    )
    return this