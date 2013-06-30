Gandalf.Views.Feed ||= {}

class Gandalf.Views.Feed.Index extends Backbone.View

  # options has keys [eventCollection, startDate, period]
  initialize: ()->
    _.bindAll(this,
      "renderSubscribedOrganizations",
      "renderSubscribedCategories"
    )
    @render()

  template: JST["backbone/templates/feed/index"]

  el: "#content"

  # Rendering functions

  renderSubscribedOrganizations: ->
    subscriptions = Gandalf.currentUser.get('subscribed_organizations')
    hidden = @options.eventCollection.getHiddenOrgs()
    # for s in subscriptions
    #       invisible = false
    #       invisible = true if s.id in hidden
    #       view = new Gandalf.Views.Organizations.Short(model: s, invisible: invisible)
    #       $("#subscribed-organizations-list").append(view.el)

  renderSubscribedCategories: ->
    subscriptions = Gandalf.currentUser.get('subscribed_categories')
    hidden = @options.eventCollection.getHiddenCats()
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
      eventCollection: @options.eventCollection
    )
    @$(".body-feed").html(eventList.el)
    nav = new Gandalf.Views.CalendarNav(
      period: @options.period
      startDate: @options.startDate
      root: ""
    )
    @$(".content-calendar-nav > .container").html(nav.el)
    cal = new Gandalf.Views.Calendar(
      type: @options.period
      eventCollection: @options.eventCollection
      startDate: @options.startDate
    )
    @$(".content-calendar").html(cal.el)
    
    $("[rel=tooltip]").tooltip(
      placement: 'right'
    )
    return this
