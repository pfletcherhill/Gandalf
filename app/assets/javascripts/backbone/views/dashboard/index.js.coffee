Gandalf.Views.Dashboard ||= {}

class Gandalf.Views.Dashboard.Index extends Backbone.View
  
  template: JST["backbone/templates/dashboard/index"]
  organizationsListTemplate: JST["backbone/templates/dashboard/organizations_list"]
  menuTemplate: JST["backbone/templates/dashboard/menu"]
  
  el: '#content'
  
  initialize: ->
    @organizations = @options.organizations
    @organization = @options.organization
    @organization.on 'updated', @updateOrganizations
    @render(@organizations, @organization, @options.section)
  
  updateOrganizations: ->
    @organizations.url = "/users/organizations"
    @organizations.fetch success: (organizations) =>
      @organizations = organizations
      @renderOrganizationsList()
    
  renderOrganizationsList: (organizations, organization)->
    @$("#dashboard-organizations-list").html @organizationsListTemplate(
      collection: organizations,
      active: organization
    )
  
  renderMenu: (organization, type) ->
    $("#dashboard-menu").html @menuTemplate(
      model: organization,
      type: type
    )
          
  render: (organizations, organization, section) ->
    @$el.html @template()
    @renderOrganizationsList(organizations, organization)
    @renderMenu(organization, section)
    return this
  
  events:
    "click #dashboard-organizations-selected" : "toggleOrganizationsList"
  
  toggleOrganizationsList: (event) ->
    $button = $("#dashboard-organizations-selected")
    if $button.hasClass "open"
      $("#dashboard-organizations-nav").hide()
      $("#button-arrow").removeClass("icon-chevron-up").addClass("icon-chevron-down")
      $button.removeClass "open"
    else
      $("#dashboard-organizations-nav").show()
      $("#button-arrow").removeClass("icon-chevron-down").addClass("icon-chevron-up")
      $button.addClass "open"