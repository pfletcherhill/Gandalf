Gandalf.Views.Dashboard ||= {}

class Gandalf.Views.Dashboard.Groups extends Backbone.View
  
  template: JST["backbone/templates/dashboard/groups/index"]
  groupTemplate: JST["backbone/templates/dashboard/groups/show"]
  table: "#dashboard-content-groups"
  
  initialize: ->
    $(@el).html @template
    @groups = new Gandalf.Collections.Teams
    @groups.url = "/organizations/#{@model.id}/teams"
    @groups.fetch success: (data) =>
      @render(@groups)
  
  addAll: (collection) ->
    for group in collection.models
      $(@table).append(@groupTemplate(group: group, organization: @model))
    
  render: (groups) ->
    @addAll(groups)
    