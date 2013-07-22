Gandalf.Views.Dashboard.Events ||= {}

class Gandalf.Views.Dashboard.Events.Index extends Backbone.View
  
  template: JST["backbone/templates/dashboard/events/index"]
  
  className: 'dash-org-container'

  events:
    "click #new-event-btn" : "createEvent"
    
  initialize: =>
    @render()
  
  convertTime: (time) ->
    moment(time).format("h:mm a")
      
  renderEvents: =>
    @collection = @model.get("events")
    @collection.on("add remove", @render)
    for e in @collection.models
      view = new Gandalf.Views.Dashboard.Event 
        model: e
        collection: @collection
      @$(".dash-list").append view.el
        
  render: =>
    @$el.html @template(@model.toJSON())
    @model.fetchEvents().then @renderEvents
    return this
  
  createEvent: ->
    Gandalf.dispatcher.trigger("event:new:start",
      organization: @model
      collection: @collection
    )
    