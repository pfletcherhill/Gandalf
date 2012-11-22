Gandalf.Views.Events ||= {}

class Gandalf.Views.Events.Browse extends Backbone.View
  
  template: JST["backbone/templates/events/browse"]
  
  id: "browse"
  
  initialize: ->
  
  addOrganizations: (organizations) ->
    _.each organizations.models, (organization) =>
      @addOrganization organization
  
  addOrganization: (organization) ->
    view = new Gandalf.Views.Events.BrowseResult(model: organization)
    @$("#browse-list").append(view.render().el)
    
  render: (organizations) ->
    $(@el).html(@template())
    @addOrganizations organizations
    return this