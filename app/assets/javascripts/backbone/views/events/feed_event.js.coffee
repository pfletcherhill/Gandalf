Gandalf.Views.Events ||= {}

class Gandalf.Views.Events.FeedEvent extends Backbone.View
  
  initialize: ->
    _.bindAll(this, "visibilityChange")
    Gandalf.dispatcher.on("eventVisibility:change", @visibilityChange)
    @render()

  events: 
    "mouseenter" : "mouseenter"
    "mouseleave" : "mouseleave"
    "click" : "click"

  template: JST["backbone/templates/events/feed_event"]

  className: "feed-event"
  
  convertTime: (time) ->
    moment(time).format("h:mm a")
    
  render: ->
    e = @model
    startTime = @convertTime e.get('start_at')
    endTime = @convertTime e.get('end_at')
    $(@el).attr(
      "data-event-id": e.get("id")
      "data-organization-id" : e.get("organization_id")
      "data-category-ids" : e.makeCatIdString()
    ).html(@template({ 
      event: e
      startTime: startTime
      endTime: endTime
    }))
    return this

  visibilityChange: (obj) ->
    time = 200
    if obj.kind == "organization"
      if parseInt(@$el.attr("data-organization-id")) == obj.id
        if obj.state == "show"
          @$el.slideDown(time)
        else if obj.state == "hide"
          @$el.slideUp(time)
    if obj.kind == "category"
      if @$el.attr("data-category-ids").indexOf(obj.id+",") != -1
        if obj.state == "show"
          @$el.slideDown(time)
        else if obj.state == "hide"
          @$el.slideUp(time)
  
  mouseenter: () ->
    Gandalf.dispatcher.trigger("feedEvent:mouseenter", @model.get("id"))
  mouseleave: () ->
    Gandalf.dispatcher.trigger("feedEvent:mouseleave", @model.get("id"))
  click: () ->
    Gandalf.dispatcher.trigger("feedEvent:click", @model.get("id"))