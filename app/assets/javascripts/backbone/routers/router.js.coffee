class Gandalf.Router extends Backbone.Router
  initialize: (options) ->
    @events = new Gandalf.Collections.Events
    @events.add options.events
    
  routes:
    'browse'      : 'browse'
    'feed'        : 'index'
    'preferences' : 'preferences'
    'about'       : 'about'
    '.*'          : 'index'
  
  index: ->
    view = new Gandalf.Views.Events.Index
    $("#events").html(view.render(@events).el)
  
  browse: ->
    view = new Gandalf.Views.Events.Browse
    $("#events").html(view.render().el)
    
  preferences: ->
    view = new Gandalf.Views.Users.Preferences
    $("#events").html(view.render().el)
  
  about: ->
    view = new Gandalf.Views.Static.About
    $("#events").html(view.render().el)
  
