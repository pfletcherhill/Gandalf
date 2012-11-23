Gandalf.Views.Events ||= {}

class Gandalf.Views.Events.FeedEvent extends Backbone.View
  
  initialize: ->
    @render()

  events: 
    "mouseenter" : "mouseenter"
    "mouseleave" : "mouseleave"
    "click" : "click"

  template: JST["backbone/templates/events/feed_event"]

  className: "feed-event"
  
  convertTime: (time) ->
    moment(time).format("h:mm a")
    
  render: ->
    startTime = @convertTime @model.get('start_at')
    endTime = @convertTime @model.get('end_at')
    $(@el).html(@template({ 
      event: @model
      startTime: startTime
      endTime: endTime
    }))
    return this
  
  mouseenter: () ->
    Gandalf.dispatcher.trigger("feedEvent:mouseenter", @model.get("id"))
  mouseleave: () ->
    Gandalf.dispatcher.trigger("feedEvent:mouseleave", @model.get("id"))
  click: () ->
    Gandalf.dispatcher.trigger("feedEvent:click", @model.get("id"))