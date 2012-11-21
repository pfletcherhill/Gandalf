Gandalf.Views.Events ||= {}

class Gandalf.Views.Events.Day extends Backbone.View
  template: JST["backbone/templates/events/day"]
  
  initialize: ->
  
  addAll: (events) ->
    _.each events, (event) =>
      @addOne(event)
  
  addOne: (event) ->
    view = new Gandalf.Views.Events.Show(model: event)
    @$("#day_events").prepend(view.render().el)
  
  convertDate: (day) ->
    date = moment(day).format("dddd, MMMM Do YYYY")
    date
          
  render: (day, events) =>
    day = @convertDate day
    $(@el).html(@template(day: day))
    @addAll events
    return this
    