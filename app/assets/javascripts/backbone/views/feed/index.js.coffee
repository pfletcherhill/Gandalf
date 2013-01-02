Gandalf.Views.Feed ||= {}

class Gandalf.Views.Feed.Index extends Backbone.View

  # options has keys [collection, startDate, period]
  initialize: ()->
    _.bindAll(this, 
      "renderSubscribedOrganizations",
      "renderSubscribedCategories"
    )
    @render()

    # Render AJAX info
    Gandalf.currentUser.fetchSubscribedOrganizations().then @renderSubscribedOrganizations
    Gandalf.currentUser.fetchSubscribedCategories().then @renderSubscribedCategories

  template: JST["backbone/templates/feed/index"]
  popoverTemplate: JST["backbone/templates/calendar/popover"]

  el: "#content"

  # Rendering functions

  renderFeed: () ->
    noEvents = "<div class='feed-day-header'>You have no upcoming events</div>"
    @$("#feed-list").append(noEvents) if _.isEmpty(@days)
    @doneEvents = []
    for day, events of @days
      @addFeedDay(day, events)

  addFeedDay: (day, events) ->
    view = new Gandalf.Views.Feed.Day(day: day, collection: events,done: @doneEvents)
    @$("#feed-list").append(view.el)

  renderSubscribedOrganizations: ->
    subscriptions = Gandalf.currentUser.get('subscribed_organizations')
    hidden = @collection.getHiddenOrgs()
    # for s in subscriptions
    #       invisible = false
    #       invisible = true if s.id in hidden
    #       view = new Gandalf.Views.Organizations.Short(model: s, invisible: invisible)
    #       $("#subscribed-organizations-list").append(view.el)
  
  renderSubscribedCategories: ->
    subscriptions = Gandalf.currentUser.get('subscribed_categories')
    hidden = @collection.getHiddenCats()
    # for s in subscriptions
    #       invisible = false
    #       invisible = true if s.id in hidden
    #       view = new Gandalf.Views.Categories.Short(model: s, invisible: invisible)
    #       $("#subscribed-categories-list").append(view.el)


  render: () ->
    @$el.html(@template({ user: Gandalf.currentUser }))
    Gandalf.calendarHeight = $(".content-calendar").height()
    # @renderFeed()
    view = new Gandalf.Views.Calendar.Index(
      type: @period
      collection: @collection
      startDate: @options.startDate
    )
    $(".content-calendar").append(view.el)
    t = this
    setInterval( ->
      t.resetEventPositions()
    , 20000)
    return this