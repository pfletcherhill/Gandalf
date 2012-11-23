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
  eventKeyFormat: "YYYY-MM-DD"
  dispatcher: _.clone(Backbone.Events)