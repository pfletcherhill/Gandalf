Gandalf.Views.Organizations ||= {}

class Gandalf.Views.Organizations.Show extends Backbone.View

  template: JST["backbone/templates/organizations/show"]

  el: '#content'

  initialize: ->
    @string = @options.string
    @render()

  renderFollowing: =>
    if Gandalf.currentUser.get('subscribed_organizations')
      if Gandalf.currentUser.isFollowing(@model, 'subscribed_organizations')
        $(".follow-button").addClass 'following btn-success'
      else
        $(".follow-button").removeClass 'following btn-success'
    else
      Gandalf.currentUser.fetchSubscribedOrganizations().then @renderFollowing

  renderCategories: ->
    categories = @model.get('categories')
    cats = []
    if categories
      for category in categories
        cats.push "<a href='#categories/#{category.id}'>#{category.name}</a>"
      @$('.organization-categories').append( cats.join(', ') )

  renderEvents: =>
    events = @model.get("events")
    view = new Gandalf.Views.Calendar.Index(
      type: @options.period
      events: events
      startDate: @options.startDate
    )
    $(".content-calendar").append(view.el)
    eventList = new Gandalf.Views.EventList (
      events: events
    )
    @$(".body-feed").html(eventList.el)
    Gandalf.dispatcher.trigger("popover:eventsReady", events)

  render: ->
    @$el.html(@template(organization: @model))
    @model.fetchEvents(@string).then @renderEvents
    # Make calendar nav (don't need events)
    Gandalf.calendarHeight = $(".content-calendar").height()
    calNav = new Gandalf.Views.CalendarNav(
      period: @options.period
      startDate: @options.startDate
      root: "organizations/#{@model.get('id')}"
    )
    @$(".content-cal-nav").html(calNav.el)
    $("[rel=tooltip]").tooltip()
    @renderCategories()
    @renderFollowing()

    return this

  events:
    "click .follow-button" : "follow"

  follow: (event) ->
    if $(event.target).hasClass 'following'
      Gandalf.currentUser.unfollowOrg(@model.id).then @renderFollowing
    else
      Gandalf.currentUser.followOrg(@model.id).then @renderFollowing
