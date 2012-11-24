Gandalf.Views.Events ||= {}

class Gandalf.Views.Events.FeedDay extends Backbone.View
  template: JST["backbone/templates/events/feed_day"]
  className: "feed-day"

  initialize: ->
    @render()

  addAll: () ->
    _.each @collection, (event) =>
      @addOne(event)
  
  addOne: (event) ->
    view = new Gandalf.Views.Events.FeedEvent(model: event)
    @$(".feed-day-events").append(view.el)
  
  convertDate: (day) ->
    date = moment(day).format("dddd, MMMM Do YYYY")
    date
          
  render: () ->
    day = @convertDate @options.day
    $(@el).html(@template(day: day))
    @addAll()
    return this
    