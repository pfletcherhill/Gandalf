Gandalf.Views.Dashboard ||= {}

class Gandalf.Views.Dashboard.Index extends Backbone.View
  
  template: JST["backbone/templates/dashboard/index"]
  menuTemplate: JST["backbone/templates/dashboard/menu"]
  
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
      view = new Gandalf.Views.Dashboard.Info(model: @organization)
    else if type == 'events'
      view = new Gandalf.Views.Dashboard.Events(model: @organization)
    else if type == 'users'
      view = new Gandalf.Views.Dashboard.Users(model: @organization)
    else
      view = new Gandalf.Views.Dashboard.Settings(model: @organization)
    @$('.content-main .main-content').html(view.el)
    return this