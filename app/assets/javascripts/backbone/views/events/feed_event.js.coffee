Gandalf.Views.Events ||= {}

class Gandalf.Views.Events.FeedEvent extends Backbone.View
  
  initialize: ->

  template: JST["backbone/templates/events/feed_event"]

  className: "feed-event"

  initialize: ->
  
  convertTime: (time) ->
    moment(time).format("h:mm a")
    
  render: ->
    startTime = @convertTime @model.get('start_at')
    endTime = @convertTime @model.get('end_at')

    $(@el).html(@template({event: @model.toJSON(), startTime: startTime, endTime: endTime}))
    return this
    