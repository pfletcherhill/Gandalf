Gandalf.Views.Feed ||= {}

class Gandalf.Views.Feed.Event extends Backbone.View

  initialize: ->
    @eventId = @model.get("eventId")
    @color = "rgba(#{@model.get("color")},0.08)"
    @darkColor = "rgba(#{@model.get("color")},1)"
    @render()

  events:
    "click" : "click"

  template: JST["backbone/templates/feed/event"]

  className: "js-event feed-event"

  render: ->
    @$el.attr(
      "data-event-id": @model.get("id")
      "data-organization-id" : @model.get("organization_id")
      "data-category-ids" : @model.makeCatIdString()
    ).css(
      borderTop: "5px solid #{@darkColor}"
    ).html(
      @template({
        event: @model
        image: @model.get('thumbnail') || "/assets/image.jpeg"
      })
    )
    return this
  
  # Trigger feed:event:click event when feed-event object is clicked
  # Do not trigger if the organization link within the object is clicked
  click: (event) ->
    unless $(event.target).hasClass "organization-link"
      Gandalf.dispatcher.trigger("feed:event:click", @eventId)
