class Gandalf.Router extends Backbone.Router
  initialize: (options) ->
    @events = new Gandalf.Collections.Events
    
  routes:
    'browse'      : 'browse'
    'feed'        : 'index'
    'preferences' : 'preferences'
    'about'       : 'about'
    '.*'          : 'index'
  
  index: ->
    @events.url = '/users/' + Gandalf.currentUser.id + '/events'
    @events.fetch success: (events) ->
      view = new Gandalf.Views.Events.Index
      $("#events").html(view.render(events).el)
  
  browse: ->
    @events.url = '/events'
    @events.fetch success: (events) ->
      view = new Gandalf.Views.Events.Browse
      $("#events").html(view.render().el)
    
  preferences: ->
    view = new Gandalf.Views.Users.Preferences
    $("#events").html(view.render().el)
  
  about: ->
    view = new Gandalf.Views.Static.About
    $("#events").html(view.render().el)
  
