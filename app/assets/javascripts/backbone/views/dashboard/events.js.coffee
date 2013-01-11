Gandalf.Views.Dashboard ||= {}

class Gandalf.Views.Dashboard.Events extends Backbone.View
  
  template: JST["backbone/templates/dashboard/events/index"]
  eventTemplate: JST["backbone/templates/dashboard/events/show"]
  
  className: 'dash-org-container'
    
  initialize: =>
    @render()
    @newEvent = new Gandalf.Models.Event
    @newEvent.set organization_id: @model.id
    @model.fetchEvents().then @renderEvents
    Gandalf.dispatcher.on("event:new:success", @eventCreated, this)
  
  convertTime: (time) ->
    moment(time).format("h:mm a")
      
  renderEvents: =>
    for e in @model.get("events").models
      @$(".dash-events-list").append( @eventTemplate( event: e))
        
  render: =>
    @$el.html @template(@model.toJSON())
    $("li[data-id='#{@model.id}']").addClass 'selected'
    return this
  
  events:
    "click #new-event-btn" : "createEvent"
  
  createEvent: ->
    Gandalf.dispatcher.trigger("event:new:start", @model)

  # Event handlers

  eventCreated: ->
    @render()
    @model.fetchEvents().then @renderEvents
    