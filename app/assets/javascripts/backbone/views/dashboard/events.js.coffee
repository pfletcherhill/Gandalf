Gandalf.Views.Dashboard ||= {}

class Gandalf.Views.Dashboard.Events extends Backbone.View
  
  template: JST["backbone/templates/dashboard/events/index"]
  eventTemplate: JST["backbone/templates/dashboard/events/show"]
  
  id: 'organization'
    
  initialize: =>
    @render()
    @newEvent = new Gandalf.Models.Event
    @newEvent.set organization_id: @model.id
    @model.fetchEvents().then @renderEvents
  
  convertTime: (time) ->
    moment(time).format("h:mm a")
      
  renderEvents: =>
    for e in @model.get("events").models
      @$("#organization-events-list").append( @eventTemplate( event: e))
        
  render: =>
    @$el.html @template(org: @model)
    $("li a[data-id='#{@model.id}']").parent().addClass 'selected'
    return this
  
  events:
    "click #new-event" : "openEvent"
    "click #close-event" : "closeEvent"
    # "submit #new-event" : "createEvent"
  
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
    