#= require_self
#= require_tree ./templates
#= require_tree ./models
#= require_tree ./views
#= require_tree ./routers

window.Gandalf =
  Models: {}
  Collections: {}
  Routers: {}
  Views: {}
  # Why use two different formats..?
  eventKeyFormat: "YYYY-MM-DD"
  displayFormat: "MM-DD-YYYY"
  dispatcher: _.clone(Backbone.Events)