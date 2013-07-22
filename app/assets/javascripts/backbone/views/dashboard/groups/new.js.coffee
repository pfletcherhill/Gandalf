Gandalf.Views.Dashboard.Groups ||= {}

class Gandalf.Views.Dashboard.Groups.New extends Backbone.View
  
  template: JST["backbone/templates/dashboard/groups/new"]
  headerTemplate: JST["backbone/templates/dashboard/groups/index"]
  
  el: ".dash-content"
  content: ".dashboard-content-main"
  
  initialize: ->
    $(@el).html @headerTemplate(organization: @options.organization)
    @newGroup = new Gandalf.Models.Team
    @render()
    
  render: ->
    $(@content).html @template()
    return this
  
  events: 
    "submit #new-group" : "saveGroup"
  
  saveGroup: (event) ->
    event.preventDefault()
    @newGroup.url = "/teams"
    params = 
      name: $("#new-group #name").val(),
      description: $("#new-group #description").html(),
      organization_id: @options.organization.id
    @newGroup.save(params,
      success: (data) =>
        window.location = "#dashboard/#{@options.organization.get('slug')}/groups"
    )
          