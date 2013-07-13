Gandalf.Views.EventList ||= {}

class Gandalf.Views.EventList extends Backbone.View

  initialize: ->
    # Discount the first event since it's rendered in 'main event'.
    toRender = new Gandalf.Collections.Events @options.eventCollection.rest()
    @days = toRender.group()
    @render()

  render: ->
    noEvents = "<div class='feed-notice'>You're not subcribed to any more events for this period. 
Check out <a href='#/browse'>the discover page</a> and start following some 
organizations and categories!</div>"
    @$el.append(noEvents) if _.isEmpty(@days)
    @doneEvents = []
    for day, events of @days
      @addEventDay(day, events)
    return this

  addEventDay: (day, events) ->
    view = new Gandalf.Views.Feed.Day(day: day, collection: events, done: @doneEvents)
    @$el.append(view.el)


