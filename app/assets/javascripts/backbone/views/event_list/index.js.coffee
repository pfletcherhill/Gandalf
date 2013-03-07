Gandalf.Views.EventList ||= {}

class Gandalf.Views.EventList extends Backbone.View

  initialize: ->
    console.log "eventlist options", @options
    @days = @options.events.group()
    @render()

  render: ->
    noEvents = "<div class='feed-notice'>No events for this period...</div>"
    @$el.append(noEvents) if _.isEmpty(@days)
    @doneEvents = []
    for day, events of @days
      @addEventDay(day, events)
    return this

  addEventDay: (day, events) ->
    view = new Gandalf.Views.Feed.Day(day: day, collection: events, done: @doneEvents)
    @$el.append(view.el)


