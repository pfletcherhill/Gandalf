class Gandalf.Router extends Backbone.Router
  initialize: (options) ->
    @events = new Gandalf.Collections.Events
    @events.add options.events
    
  routes:
    '.*' : 'index'
  
  index: ->
    view = new Gandalf.Views.Events.Index
    $("#events").html(view.render(@events).el)
  
