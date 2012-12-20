Gandalf.Views.Organizations ||= {}

class Gandalf.Views.Organizations.Events extends Backbone.View
  
  template: JST["backbone/templates/organizations/events/index"]
  eventTemplate: JST["backbone/templates/organizations/events/event"]
  
  id: 'organization'
    
  initialize: =>
    @render()
    @newEvent = new Gandalf.Models.Event
    @newEvent.set organization_id: @model.id
    @model.fetchEvents().then @renderEvents
  
  convertTime: (time) ->
    moment(time).format("h:mm a")
      
  renderEvents: =>
    for event in @model.get('events')
      startTime = @convertTime event.start_at
      @$("#organization-events-list").append( @eventTemplate( event: event, startTime: startTime ))
        
  render: =>
    $(@el).html(@template( @model.toJSON() ))
    $("li a[data-id='#{@model.id}']").parent().addClass 'selected'
    return this
  
  events:
    "click button#new-event" : "openEvent"
    "click button#close-event" : "closeEvent"
    "submit form#new-event" : "createEvent"
  
  openEvent: ->
    @$("#event-form").addClass 'open'
    @$("form#new-event").backboneLink(@newEvent)
  
  closeEvent: ->
    @$("#event-form").removeClass 'open'
  
  createEvent: (event) ->
    event.preventDefault()
    event.stopPropagation()
    @$("form#new-event button").html('Saving...')
    @newEvent.url = "/events/create"
    @newEvent.save(@newEvent,
      success: (event) =>
        @render()
        @model.fetchEvents().then @renderEvents
      error: (event, jqXHR) =>
        console.log event
        @$("form#new-event button").html('Save Event...')
        @newEvent.set({errors: $.parseJSON(jqXHR.responseText)})
    )
    