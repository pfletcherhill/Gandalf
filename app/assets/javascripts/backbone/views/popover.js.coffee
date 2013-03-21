Gandalf.Views ||= {}

class Gandalf.Views.Popover extends Backbone.View

  initialize: ->
    # All popover event handlers
    @myEvents = @options.events
    Gandalf.dispatcher.on("event:click", @showEvent, this)
    Gandalf.dispatcher.on("event:new:start", @newEvent, this)
    Gandalf.dispatcher.on("event:edit", @editEvent, this)
    Gandalf.dispatcher.on("popover:hide", @hide, this)
    Gandalf.dispatcher.on("route", @hide, this)
    Gandalf.dispatcher.on("dashboard:email", @showEmail, this)
    Gandalf.dispatcher.on("popover:eventsReady", @setEvents, this)
    @render()

  id: "popover-container"
  template: JST["backbone/templates/popover/index"]
  showEventTemplate: JST["backbone/templates/popover/events/show"]
  newEventTemplate: JST["backbone/templates/popover/events/new"]
  editEventTemplate: JST["backbone/templates/popover/events/edit"]
  showEmailTemplate: JST["backbone/templates/popover/email"]

  events:
    "submit #new-event-form": "createEvent"
    "submit #edit-event-form": "updateEvent"
    "click input,textarea" : "removeErrorClass"
    "click .global-overlay,.close,a" : "hide"
    "click #send-email": "sendEmail"

  render: ->
    @$el.html @template()
    return this

  # Email event handlers
  showEmail: (object) ->
    console.log object
    @emails = object.emails
    @organization = object.organization
    color = "rgba(#{@organization.get("color")}, 0.7)"
    $(".gandalf-popover").html @showEmailTemplate(organization: @organization, emailCount: @emails.length, color: color)
    @show()

  sendEmail: ->
    emails = @emails
    orgId = @organization.id
    body = @$(".email-compose").val()
    subject = @$(".email-subject").val()
    $.post(
      '/organizations/' + orgId + '/email',
      { user_ids: emails, body: body, subject: subject },
      (data) ->
        alert("Response: " + data)
    )
    # $.ajax
    #       type: 'POST'
    #       dataType: 'json'
    #       url: '/organizations/' + orgId + '/email', { user_ids: emails, body: body, subject: subject }
    #       success: (data) =>
    #         console.log data

  # Events event handlers
  showEvent: (object) ->
    model = object.model
    color = object.color
    eId = model.get("eventId")
    if model.get("id") isnt eId
      model = @myEvents.get(eId)
    $(".gandalf-popover").html @showEventTemplate(e: model, color: color)
    @show()
    @makeGMap(model)
    console.log window.location.hash
    if /calendar/.test window.location.hash
      @makeWhyEventIsShown(model) 
    else
      $(".why").hide()

  newEvent: (organization) ->
    e = new Gandalf.Models.Event
    e.set organization_id: organization.get("id")
    $(".gandalf-popover").html @newEventTemplate(
      org: organization
      color: "rgba(#{organization.get("color")}, 0.7)"
      categories: Gandalf.constants.allCategories.models
    )
    $("[type=datetime]").datepicker()
    @makeChosen()
    @makeAutoComplete()
    @show()

  editEvent: (e) ->
    $(".gandalf-popover").html @editEventTemplate(
      event: e
      color: "rgba(#{e.get("color")}, 0.7)"
      categories: Gandalf.constants.allCategories.models
    )
    @makeChosen(_.pluck(e.get("categories"), "id"))
    @makeAutoComplete()
    @show()

  createEvent: () ->
    values = @validateEvent();
    return false if not values
    @$("[type='submit']").val('Saving...')
    newEvent = new Gandalf.Models.Event
    newEvent.set values
    console.log newEvent
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
    # Description, category_ids fields not required,
    # so not in validation process
    values["description"] = $("textarea[name='description']").val()
    values["category_ids"] = $("#category-select").val()
    # Remove keys not associated with event
    delete values["start_at_time"]
    delete values["start_at_date"]
    delete values["end_at_time"]
    delete values["end_at_date"]

    return values

  setEvents: (evs) ->
    console.log evs
    @myEvents = evs

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

  makeAutoComplete: ->
    $("input[name=location]").autocomplete(
      source: (request, response) ->
        $.ajax "/search/location/#{request.term}", 
          dataType: 'json'
          success: (data) ->
            response(data)
          error: ->
            response([])
    )

  makeChosen: (ids) ->
    $("#category-select").chosen()
    if not _.isEmpty ids
      $('#category-select').val(ids).trigger('liszt:updated') 
    $("#category_select_chzn").css(
      width: "431px"
      marginBottom: "10px"
    )
    $(".chzn-drop").css(width: "90%")

  makeWhyEventIsShown: (model) ->
    following_org_ids = 
      Gandalf.currentUser.get("subscribed_organizations").pluck "id"
    following_cat_ids = 
      Gandalf.currentUser.get("subscribed_categories").pluck "id"
    model_org_id  = model.get("organization_id")
    model_cat_ids = _.pluck(model.get("categories"), "id")
    matching_cats = _.intersection(model_cat_ids, following_cat_ids)
    why = "#{model.get('name')} shows on your calendar because you're following "
    if model.get("organization_id") in following_org_ids
      why += "the sponsoring organization "
      why += "<a href='#/organizations/#{model_org_id}'>#{model.get("organization")}</a>"
      why += " and " if not _.isEmpty(matching_cats)
    if not _.isEmpty(matching_cats)
      if matching_cats.length is 1 then why += "the category " 
      else 
        why += "the categories "
      first = true
      for cat_id in matching_cats
        if not first
          why += ", "
        else
          first = false
        cat = Gandalf.currentUser.get("subscribed_categories").get(cat_id)
        why += "<a href='#/categories/#{cat_id}'>#{cat.get('name')}</a>"
    why += "."
    $(".why").popover
      html: true
      placement: "bottom"
      trigger: "click"
      title: "Why is this on my calendar?"
      content: why

    # console.log "SHOW:", model.get("organization_id")
    # console.log _.pluck(model.get("categories"), "id")
    # console.log Gandalf.currentUser.get("subscribed_organizations").pluck "id"
    # console.log Gandalf.currentUser.get("subscribed_categories").pluck "id"