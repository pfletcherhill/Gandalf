Gandalf.Views.Feed ||= {}

class Gandalf.Views.Feed.Day extends Backbone.View
  
  template: JST["backbone/templates/feed/day"]
  className: "feed-day"

  initialize: ->
    @render()

  addAll: () ->
    @numAdded = 0
    for event in @collection
      @addOne event
  
  addOne: (event) ->
    # Don't render if this event has already been rendered in a 
    # previous day — this only applies to multi-day events
    return if event.get("eventId") in @options.done
    view = new Gandalf.Views.Feed.Event(model: event)
    @$(".feed-day-events").append(view.el)
    # Add this event to the list of done events
    @numAdded++
    @options.done.push event.get("eventId")
          
  render: () ->
    day = Gandalf.formatDate moment(@options.day)
    @$el.html @template(day: day)
    @addAll()
    @$el.html "" if @numAdded is 0 # Don't render the day header unnecessarily
    return this
    
