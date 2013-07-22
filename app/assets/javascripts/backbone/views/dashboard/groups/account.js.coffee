Gandalf.Views.Dashboard.Groups ||= {}

class Gandalf.Views.Dashboard.Groups.Account extends Backbone.View
  
  template: JST["backbone/templates/dashboard/groups/show"]
  headerTemplate: JST["backbone/templates/dashboard/groups/index"]
  
  el: ".dash-content"
  content: ".dashboard-content-main"
  
  initialize: ->
    $(@el).html @headerTemplate
      organization: @options.organization,
      group: @model
    @render()
    
  render: ->
    $(@content).html @template(@model.toJSON())
