Gandalf.Views.Organizations ||= {}

class Gandalf.Views.Organizations.Events extends Backbone.View
  
  template: JST["backbone/templates/organizations/events/index"]
  eventTemplate: JST["backbone/templates/organizations/events/event"]
  
  id: 'organization'
    
  initialize: =>
    @render()
    @model.fetchEvents().then @renderEvents
  
  convertTime: (time) ->
    moment(time).format("h:mm a")
      
  renderEvents: =>
    for event in @model.get('events')
      startTime = @convertTime event.start_at
      @$("#organization-events-list").append( @eventTemplate( event: event, startTime: startTime ))
        
  render: ->
    $(@el).html(@template( @model.toJSON() ))
    $("li a[data-id='#{@model.id}']").parent().addClass 'selected'
    return this
    