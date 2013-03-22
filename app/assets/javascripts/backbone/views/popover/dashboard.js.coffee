# Popover for the Dashboard.
# With methods for showing the new/edit event popovers 
# and their validation/creation/updating
class Gandalf.Views.DashboardPopover extends Gandalf.Views.Popover

  initialize: ->
    # Initialize Gandalf.Views.Popover, which calls its render
    super()

    # Event handlers
    Gandalf.dispatcher.on("event:new:start", @newEvent, this)
    Gandalf.dispatcher.on("event:edit", @editEvent, this)
    Gandalf.dispatcher.on("dashboard:email", @showEmail, this)

  newEventTemplate: JST["backbone/templates/popover/events/new"]
  editEventTemplate: JST["backbone/templates/popover/events/edit"]
  showEmailTemplate: JST["backbone/templates/popover/email"]

  events: 
    "click .global-overlay,.close,a" : "hide"
    "click input,textarea" : "removeErrorClass"
    "submit #new-event-form": "createEvent"
    "submit #edit-event-form": "updateEvent"
    "click #send-email": "sendEmail"

  newEvent: (obj) ->
    @collection = obj.collection
    organization = obj.organization
    e = new Gandalf.Models.Event
    e.set organization_id: organization.get("id")
    $(".gandalf-popover").html @newEventTemplate(
      org: organization
      color: "rgba(#{organization.get("color")}, 0.7)"
      categories: Gandalf.constants.allCategories.models
    )
    $("[type=datetime]").datepicker()
    @show()
    @makeChosen()
    @makeAutoComplete()

  editEvent: (obj) ->
    @collection = obj.collection
    e = obj.event
    $(".gandalf-popover").html @editEventTemplate(
      event: e
      color: "rgba(#{e.get("color")}, 0.7)"
      categories: Gandalf.constants.allCategories.models
    )
    @show()
    @makeChosen(_.pluck(e.get("categories"), "id"))
    @makeAutoComplete()

  # When the new/edit forms return 

  createEvent: () ->
    values = @validateEvent();
    return false if not values
    @$("[type='submit']").val('Saving...')
    newEvent = new Gandalf.Models.Event
    newEvent.set values
    newEvent.url = "/events"
    newEvent.save(newEvent,
      success: (e) =>
        @hide()
        @collection.add e
        console.log @collection
        # Gandalf.dispatcher.trigger("event:change", e)
        Gandalf.dispatcher.trigger("flash:success", "#{e.get('name')} created!")
      error: (organization, jqXHR) =>
        Gandalf.dispatcher.trigger("flash:error", "Couldn't create event.")
        newEvent.set({errors: $.parseJSON(jqXHR.responseText)})
        console.log $.parseJSON(jqXHR.responseText)
    )
    # So the browser doesn't submit the event
    return false

  updateEvent: () ->
    values = @validateEvent()
    return false if not values
    t = this
    @$("[type='submit']").val('Updating...')
    eventId = $("[name=event_id]").val()
    e = @collection.get(eventId)
    e.set values
    e.save(values,
      success: (e) =>
        @hide()
        Gandalf.dispatcher.trigger("event:change", e)
        Gandalf.dispatcher.trigger("flash:success", "#{e.get('name')} updated.")
      error: (organization, jqXHR) =>
        Gandalf.dispatcher.trigger("flash:error", "Couldn't update event.")
        e.set({errors: $.parseJSON(jqXHR.responseText)})
        console.log $.parseJSON(jqXHR.responseText)
    )

    return false

  # Helpers

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
    # Description, category_ids, room_number fields not required,
    # so not in validation process
    values["description"] = $("textarea[name='description']").val()
    values["category_ids"] = $("#category-select").val()
    values["room_number"] = $("input[name=room_number]").val()
    # Remove keys not associated with event
    delete values["start_at_time"]
    delete values["start_at_date"]
    delete values["end_at_time"]
    delete values["end_at_date"]

    return values

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

  removeErrorClass: (e) ->
    $(e.target).removeClass "error"


  # Temporary mail event handlers
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
