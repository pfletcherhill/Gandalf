Gandalf.Views.Organizations ||= {}

class Gandalf.Views.Organizations.Index extends Backbone.View
  
  template: JST["backbone/templates/organizations/index"]
  
  el: '#content'
  
  initialize: ->
    @organizations = @options.organizations
    @render()
  
  renderOrganizationsList: ->
    for organization in @organizations.models
      @$(".left-list").append("<li><a data-id=#{organization.id} href='#organizations/#{organization.id}'>#{organization.get('name')}</a></li>")
        
  render: =>
    $(@el).html(@template())
    @renderOrganizationsList()
    return this