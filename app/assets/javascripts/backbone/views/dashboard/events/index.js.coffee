Gandalf.Views.Dashboard ||= {}

class Gandalf.Views.Dashboard.Events extends Backbone.View
  
  template: JST["backbone/templates/dashboard/events/index"]
  
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
      view = new Gandalf.Views.Dashboard.Event model: e
      @$(".dash-list").append view.el
        
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
    