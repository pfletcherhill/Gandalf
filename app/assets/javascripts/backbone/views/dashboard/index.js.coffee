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
      @$(".left-list").append("<a href='#dashboard/#{organization.id}'><li data-id=#{organization.id}>#{organization.get('name')}</li></a>")
  
  renderOrganizationMenu: (type) ->
    @$('.dash-menu').html( @menuTemplate( @organization.toJSON()) )
    @$(".dash-menu li[data-type=#{type}]").addClass 'selected'
          
  render: (type) =>
    @$el.html @template()
    @renderOrganizationsList()
    @renderOrganizationMenu(type)
    if type is 'events'
      view = new Gandalf.Views.Dashboard.Events(model: @organization)
    else if type is'users'
      view = new Gandalf.Views.Dashboard.Users(model: @organization)
    else if type is 'settings'
      view = new Gandalf.Views.Dashboard.Settings(model: @organization)
    else # Should never happen
      view = new Gandalf.Views.Dashboard.Events(model: @organization)
      
    @$('.content-main .dash-content').html view.el
    return this