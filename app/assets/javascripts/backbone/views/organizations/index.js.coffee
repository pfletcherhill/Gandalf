Gandalf.Views.Organizations ||= {}

class Gandalf.Views.Organizations.Index extends Backbone.View
  
  template: JST["backbone/templates/organizations/index"]
  
  el: '#content'
  
  initialize: ->
    @organizations = @options.organizations
    @organization = @options.organization
    @organization.on 'updated', @updateOrganizations
    @render(@organization)
  
  updateOrganizations: =>
    @organizations.url = "/users/#{Gandalf.currentUser.id}/organizations"
    @organizations.fetch success: (organizations) =>
      @organizations = organizations
      @renderOrganizationsList()
    
  renderOrganizationsList: =>
    @$(".left-list").html('')
    for organization in @organizations.models
      @$(".left-list").append("<li><a data-id=#{organization.id} href='#organizations/#{organization.id}'>#{organization.get('name')}</a></li>")
  
  renderOrganization: (organization) ->
    view = new Gandalf.Views.Organizations.Edit(model: organization)
    @$('.main').html(view.el)
          
  render: (organization) =>
    $(@el).html(@template())
    @renderOrganizationsList()
    @renderOrganization(organization)
    return this