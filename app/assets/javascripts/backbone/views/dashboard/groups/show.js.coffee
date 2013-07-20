Gandalf.Views.Dashboard ||= {}

class Gandalf.Views.Dashboard.Groups.Show extends Backbone.View
  
  template: JST["backbone/templates/groups/show"]
  el: ".dashboard-content-main"
  
  initialize: ->
    @render()
    
  render: ->
    $(@el).html @template(@model.toJSON())
