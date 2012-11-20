Gandalf.Views.Events ||= {}

class Gandalf.Views.Events.Index extends Backbone.View
  template: JST["backbone/templates/events/index"]
  
  initialize: ->
  
  addAll: (events) ->
    days = _.groupBy(events.models, (event) ->
        return event.get('date')
    )
    _.each days, (events, day) =>
      @addDay(day, events)

  addDay: (day, events) ->
    view = new Gandalf.Views.Events.Day()
    @$("#events_list").prepend(view.render(day, events).el)
    
  render: (events) ->
    $(@el).html(@template(user: Gandalf.currentUser))
    @addAll(events)
    return this
    
    