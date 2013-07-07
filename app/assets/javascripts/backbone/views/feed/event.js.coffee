Gandalf.Views.Feed ||= {}

class Gandalf.Views.Feed.Event extends Backbone.View

  initialize: ->
    @eventId = @model.get("eventId")
    @color = "rgba(#{@model.get("color")},0.08)"
    @darkColor = "rgba(#{@model.get("color")},1)"
    @render()

  events:
    #"mouseenter" : "mouseenter"
    #"mouseleave" : "mouseleave"
    "click" : "click"

  template: JST["backbone/templates/feed/event"]

  className: "js-event feed-event"

  render: ->
    e = @model
    @$el.attr(
      "data-event-id": e.get("id")
      "data-organization-id" : e.get("organization_id")
      "data-category-ids" : e.makeCatIdString()
    ).css(
      borderTop: "5px solid #{@darkColor}"
    ).html(@template({
      event: e
      image: e.get('thumbnail') || "/assets/image.jpeg"
    }))
    return this

  mouseenter: () ->
    @$el.css({ backgroundColor: @darkColor })
    Gandalf.dispatcher.trigger("feed:event:mouseenter", @eventId)
  mouseleave: () ->
    @$el.css({ backgroundColor: @color })
    Gandalf.dispatcher.trigger("feed:event:mouseleave", @eventId)
  click: () ->
    Gandalf.dispatcher.trigger("feed:event:click", @eventId)
