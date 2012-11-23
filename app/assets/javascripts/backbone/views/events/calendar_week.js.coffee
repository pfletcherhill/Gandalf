Gandalf.Views.Events ||= {}

class Gandalf.Views.Events.CalendarWeek extends Backbone.View
  initialize: ()->
    _.bindAll(this, "scrollToEvent")
    @render()
    Gandalf.dispatcher.bind("feedEvent:click", @scrollToEvent)

  template: JST["backbone/templates/events/calendar_week"]
  
  tagName: "div"
  className: "cal week-cal"

  events:
    "click .hour-day" : "hidePopovers"
  
  render: () ->
    $(@el).html(@template(startDate: @options.startDate))
    return this

  hidePopovers: () ->
    $("[rel='event-popover']").popover("hide")

  scrollToEvent: (id) ->
    top = $(".cal-event[data-event-id='"+id+"']:first").css("top")
    console.log(parseInt(top))
    # Not working for some reason...
    @$el.scrollTop(parseInt(top))
