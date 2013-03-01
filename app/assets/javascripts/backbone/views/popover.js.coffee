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
    "submit #new-event-form": "createEvent"
    "submit #edit-event-form": "updateEvent"
    "click input,textarea" : "removeErrorClass"
    "click .global-overlay,.close,a" : "hide"

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
    $("[type=datetime]").datepicker()
    @show()

  editEvent: (e) ->
    $(".gandalf-popover").html @editEventTemplate(
      event: e
      color: "rgba(#{e.get("color")}, 0.7)"
    )
    @show()

  createEvent: () ->
    values = @validateEvent();
    return false if not values
    console.log "values", values
    console.log $("input[name=organization_id]")
    @$("[type='submit']").val('Saving...')
    newEvent = new Gandalf.Models.Event 
    newEvent.set values
    newEvent.url = "/events"
    newEvent.save(newEvent, 
      success: (e) =>
        @hide()
        Gandalf.dispatcher.trigger("event:change")
        Gandalf.dispatcher.trigger("flash:success", "#{e.get('name')} created!")
      error: (organization, jqXHR) =>
        Gandalf.dispatcher.trigger("flash:error", {org: organization, xhr: jqXHR})
        @model.set({errors: $.parseJSON(jqXHR.responseText)})
    )
    # So the browser doesn't submit the event
    return false

  updateEvent: () ->
    values = @validateEvent()
    return false if not values
    t = this
    @$("[type='submit']").val('Updating...')
    eventId = $("[name=event_id]").val()
    e = new Gandalf.Models.Event
    e.url = "/events/#{eventId}"
    e.fetch(
      success: =>
        e.set values
        e.save(values,
          success: (e) =>
            @hide()
            Gandalf.dispatcher.trigger("event:change")
            Gandalf.dispatcher.trigger("flash:success", "#{e.get('name')} updated.")
          error: (organization, jqXHR) =>
            Gandalf.dispatcher.trigger("flash:error", {org: organization, xhr: jqXHR})
            e.set({errors: $.parseJSON(jqXHR.responseText)})
        )
    )

    return false


  validateEvent: () ->
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
    # If validation failed return null
    return null if not success
    
    # Consolidate time and date into datetime
    start = moment(values["start_at_time"]+" "+values["start_at_date"], "HH:mm MM/DD/YYYY")
    end = moment(values["end_at_time"]+" "+values["end_at_date"], "HH:mm MM/DD/YYYY")
    values["start_at"] = start.format()
    values["end_at"] = end.format()
    # Description field is not required, so not in validation process
    values["description"] = @$("textarea[name='description']").val()
    # Remove keys not associated with event
    delete values["start_at_time"]
    delete values["start_at_date"]
    delete values["end_at_time"]
    delete values["end_at_date"]

    return values 

  # Helpers

  show: ->
    $(".gandalf-popover,.global-overlay").fadeIn "fast"

  hide: ->
    $(".gandalf-popover,.global-overlay").fadeOut("fast")

  removeErrorClass: (e) ->
    $(e.target).removeClass "error"

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