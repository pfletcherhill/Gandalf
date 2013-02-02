Gandalf.Views ||= {}

class Gandalf.Views.Popover extends Backbone.View

  initialize: ->
    # All popover event handlers
    Gandalf.dispatcher.on("event:click", @showEvent, this)
    Gandalf.dispatcher.on("event:new:start", @newEvent, this)
    Gandalf.dispatcher.on("event:edit", @editEvent, this)
    Gandalf.dispatcher.on("popover:hide", @hide, this)
    @render()

  id: "popover-container"
  template: JST["backbone/templates/popover/index"]
  showEventTemplate: JST["backbone/templates/popover/events/show"]
  newEventTemplate: JST["backbone/templates/popover/events/new"]
  editEventTemplate: JST["backbone/templates/popover/events/edit"]

  events:
    "submit #new-event-form": "validateNewEvent"
    "click input,textarea" : "removeErrorClass"
    "click .global-overlay,.close" : "hide"

  render: ->
    @$el.html @template()
    return this

  # Event handlers

  showEvent: (object) ->
    model = object.model
    color = object.color
    eId = model.get("eventId")
    if model.get("id") isnt eId
      model = @options.events.get(eId)
    $(".gandalf-popover").html @showEventTemplate(e: model, color: color)
    @show()
    @makeGMap(model)

  newEvent: (organization) ->
    e = new Gandalf.Models.Event
    e.set organization_id: organization.get("id")
    $(".gandalf-popover").html @newEventTemplate(
      org: organization
      color: "rgba(#{organization.get("color")}, 0.7)"
    )
    console.log $("[type=datetime]")
    $("[type=datetime]").datepicker()
    @show()

  editEvent: (e) ->
    console.log "event", e
    $(".gandalf-popover").html @editEventTemplate(
      event: e
      color: "rgba(#{e.get("color")}, 0.7)"
    )
    @show()

  validateNewEvent: (e) ->
    # These strings are Ruby style bc we do e.set in @makeEvent()
    names = [
      'name', 
      'location', 
      'start_at_date', 
      'start_at_time', 
      'end_at_date', 
      'end_at_time', 
      'organization_id'
    ]
    values = {}
    success = true
    for name in names
      input = @$("input[name='#{name}']")
      value = $(input).val()
      if not value
        $(input).addClass "error"
        $(input).attr "placeholder", "This is required!"
        success = false
        values[name] = "None"
      else
        values[name] = value
    # return false unless success
    start = moment(values["start_at_time"]+" "+values["start_at_date"], "HH:mm MM/DD/YYYY")
    end = moment(values["end_at_time"]+" "+values["end_at_date"], "HH:mm MM/DD/YYYY")
    values["start_at"] = start.format()
    values["end_at"] = end.format()
    # Description field is not required
    values["description"] = @$("textarea[name='description']").val()
    # Handle times here
    @makeEvent(values)

  makeEvent: (values) ->
    @$("[type='submit']").val('Saving...')
    newEvent = new Gandalf.Models.Event 
    newEvent.set values
    console.log newEvent
    newEvent.url = "/events/create"
    t = this
    newEvent.save(newEvent, 
      success: (e) =>
        console.log "new event success", e
        @hide()
      error: (organization, jqXHR) =>
        console.log "new event error", organization, jqXHR
        @model.set({errors: $.parseJSON(jqXHR.responseText)})
    )
    return false

    # name: null
    # location
    # address
    # start_at: null
    # end_at: null
    # organization_id: null
    # description: null

  removeErrorClass: (e) ->
    $(e.target).removeClass "error"

  hide: ->
    $(".gandalf-popover,.global-overlay").fadeOut("fast")

  # Helpers

  show: ->
    $(".gandalf-popover,.global-overlay").fadeIn "fast"

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