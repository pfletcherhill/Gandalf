Gandalf.Views.Feed ||= {}

class Gandalf.Views.Feed.Index extends Backbone.View

  # options has keys [events, startDate, period]
  initialize: ()->
    _.bindAll(this, 
      "renderSubscribedOrganizations",
      "renderSubscribedCategories"
    )
    @render()

    # Render AJAX info
    Gandalf.currentUser.fetchSubscribedOrganizations().then @renderSubscribedOrganizations
    Gandalf.currentUser.fetchSubscribedCategories().then @renderSubscribedCategories
    Gandalf.dispatcher.on("event:click", @showPopover, this)
    Gandalf.dispatcher.on("popover:hide", @hidePopover, this)

  template: JST["backbone/templates/feed/index"]
  popoverTemplate: JST["backbone/templates/calendar/popover"]

  el: "#content"

  events:
    "click .global-overlay" : "hidePopover"

  # Rendering functions

  renderFeed: () ->
    noEvents = "<div class='feed-day-header'>You have no upcoming events</div>"
    @$("#body-feed").append(noEvents) if _.isEmpty(@days)
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
    @$el.html(@template({ user: Gandalf.currentUser }))
    Gandalf.calendarHeight = $(".content-calendar").height()
    @days = @options.events.group()
    @renderFeed()
    view = new Gandalf.Views.Calendar.Index(
      type: @options.period
      events: @options.events
      startDate: @options.startDate
    )

    $(".content-calendar").append(view.el)
    return this

  showPopover: (object) ->
    model = object.model
    color = object.color
    eId = model.get("eventId")
    if model.get("id") isnt eId
      model = @options.events.get(eId)
    $(".cal-popover").html(@popoverTemplate(e: model, color: color))
    $(".cal-popover,.global-overlay").fadeIn("fast")
    $(".cal-popover .close").click( ->
      Gandalf.dispatcher.trigger("popover:hide")
    )
    @makeGMap(model)

  makeGMap: (model) ->
    myPos = new google.maps.LatLng(model.get("lat"), model.get("lon"))
    options = 
      center: myPos
      zoom: 15
      mapTypeId: google.maps.MapTypeId.ROADMAP
    map = new google.maps.Map(document.getElementById("map-canvas"), options)
    marker = new google.maps.Marker(
      position: myPos
      map: map
      title: "Here it is!"
    )

  hidePopover: ->
    $(".cal-popover,.global-overlay").fadeOut("fast")
