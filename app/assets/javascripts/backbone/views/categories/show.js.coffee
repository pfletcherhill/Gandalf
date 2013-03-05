Gandalf.Views.Categories ||= {}

class Gandalf.Views.Categories.Show extends Backbone.View

  template: JST["backbone/templates/categories/show"]

  el: '#content'

  initialize: ->
    @string = @options.string
    @render()

  renderFollowing: =>
    if Gandalf.currentUser.get('subscribed_categories')
      if Gandalf.currentUser.isFollowing(@model, 'subscribed_categories')
        $(".follow-button").addClass 'following btn-success'
      else
        $(".follow-button").removeClass 'following btn-success'
    else
      Gandalf.currentUser.fetchSubscribedCategories().then @renderFollowing

  renderEvents: =>
    events = @model.get("events")
    view = new Gandalf.Views.Calendar.Index(
      type: @options.period
      events: events
      startDate: @options.startDate
    )
    $(".content-calendar").append(view.el)

  render: ->
    @$el.html(@template( category: @model ))
    Gandalf.calendarHeight = $(".content-calendar").height()
    calNav = new Gandalf.Views.CalendarNav(
      period: @options.period
      startDate: @options.startDate
      root: "categories/#{@model.get('id')}"
    )
    @$(".content-cal-nav").html(calNav.el)
    @renderFollowing()
    @model.fetchEvents(@string).then @renderEvents
    return this

  events:
    "click .follow-button" : "follow"

  follow: (event) ->
    if $(event.target).hasClass 'following'
      Gandalf.currentUser.unfollowCat(@model).then @renderFollowing
    else
      Gandalf.currentUser.followCat(@model).then @renderFollowing