Gandalf.Views.Events ||= {}

class Gandalf.Views.Events.FeedEvent extends Backbone.View
  
  initialize: ->
    @render()

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
    