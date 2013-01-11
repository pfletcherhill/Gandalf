Gandalf.Views ||= {}

class Gandalf.Views.Popover extends Backbone.View

  initialize: ->
    # All popover event handlers
    Gandalf.dispatcher.on("event:click", @showEvent, this)
    Gandalf.dispatcher.on("popover:hide", @hide, this)
    @render()

  id: "popover-container"
  template: JST["backbone/templates/popover/index"]
  eventTemplate: JST["backbone/templates/popover/event"]

  events:
    "click .global-overlay" : "hide"

  render: ->
    @$el.html @template()
    return this

  showEvent: (object) ->
    model = object.model
    color = object.color
    eId = model.get("eventId")
    if model.get("id") isnt eId
      model = @options.events.get(eId)

    console.log  $(".gandalf-popover")
    $(".gandalf-popover").html @eventTemplate(e: model, color: color)
    $(".gandalf-popover,.global-overlay").fadeIn "fast"
    $(".gandalf-popover .close").click( ->
      Gandalf.dispatcher.trigger "popover:hide"
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

  hide: ->
    $(".gandalf-popover,.global-overlay").fadeOut("fast")