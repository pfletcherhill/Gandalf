Gandalf.Views.Events ||= {}

class Gandalf.Views.Events.FeedEvent extends Backbone.View
  
  initialize: ->

  template: JST["backbone/templates/events/feed_event"]

  className: "feed-event"

  initialize: ->
  
  convertTime: (time) ->
    moment(time).format("h:mm a")
    
  render: ->
    start_time = @convertTime @model.get('start_at')
    end_time = @convertTime @model.get('end_at')

    $(@el).html(@template({event: @model.toJSON(), start_time: start_time, end_time: end_time}))
    return this
    