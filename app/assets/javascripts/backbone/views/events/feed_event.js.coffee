Gandalf.Views.Events ||= {}

class Gandalf.Views.Events.FeedEvent extends Backbone.View
  
  initialize: ->
    @eventId = @model.get("eventId")
    @render()

  events: 
    "mouseenter" : "mouseenter"
    "mouseleave" : "mouseleave"
    "click" : "click"

  template: JST["backbone/templates/events/feed_event"]

  className: "js-event feed-event"
  
  convertTime: (time) ->
    moment(time).format("h:mm a")
    
  render: ->
    e = @model
    startTime = @convertTime e.get('start_at')
    endTime = @convertTime e.get('end_at')
    $(@el).attr(
      "data-event-id": e.get("id")
      "data-organization-id" : e.get("organization_id")
      "data-category-ids" : e.makeCatIdString()
    ).html(@template({ 
      event: e
      startTime: startTime
      endTime: endTime
    }))
    return this
  
  mouseenter: () ->
    Gandalf.dispatcher.trigger("feedEvent:mouseenter", @eventId)
  mouseleave: () ->
    Gandalf.dispatcher.trigger("feedEvent:mouseleave", @eventId)
  click: () ->
    Gandalf.dispatcher.trigger("feedEvent:click", @eventId)