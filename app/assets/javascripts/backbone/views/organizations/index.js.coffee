Gandalf.Views.Organizations ||= {}

class Gandalf.Views.Organizations.Index extends Backbone.View
  
  template: JST["backbone/templates/organizations/index"]
  menuTemplate: JST["backbone/templates/organizations/menu"]
  
  el: '#content'
  
  initialize: ->
    @organizations = @options.organizations
    @organization = @options.organization
    @organization.on 'updated', @updateOrganizations
    @render(@options.type)
  
  updateOrganizations: =>
    @organizations.url = "/users/#{Gandalf.currentUser.id}/organizations"
    @organizations.fetch success: (organizations) =>
      @organizations = organizations
      @renderOrganizationsList()
    
  renderOrganizationsList: =>
    @$(".left-list").html('')
    for organization in @organizations.models
      @$(".left-list").append("<li><a data-id=#{organization.id} href='#organizations/edit/#{organization.id}'>#{organization.get('name')}</a></li>")
  
  renderOrganizationMenu: (type) ->
    @$('.main-menu').html( @menuTemplate( @organization.toJSON()) )
    @$('.main-menu a[data-type=' + type + ']').addClass 'selected'
          
  render: (type) =>
    $(@el).html(@template())
    @renderOrganizationsList()
    @renderOrganizationMenu(type)
    if type == 'info'
      view = new Gandalf.Views.Organizations.Info(model: @organization)
    else if type == 'events'
      view = new Gandalf.Views.Organizations.Events(model: @organization)
    else if type == 'users'
      view = new Gandalf.Views.Organizations.Users(model: @organization)
    else
      view = new Gandalf.Views.Organizations.Settings(model: @organization)
    @$('.content-main .main-content').html(view.el)
    return this