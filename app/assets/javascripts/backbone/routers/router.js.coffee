class Gandalf.Router extends Backbone.Router
  initialize: (options) ->

  routes:
    '.*' : 'index'
  
  index: ->
    view = new Gandalf.Views.Events.Index
  
