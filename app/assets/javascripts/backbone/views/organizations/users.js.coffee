Gandalf.Views.Organizations ||= {}

class Gandalf.Views.Organizations.Users extends Backbone.View
  
  template: JST["backbone/templates/organizations/users/index"]
  userTemplate: JST["backbone/templates/organizations/users/user"]
  
  id: 'organization'
    
  initialize: =>
    @render()
    @model.fetchEvents().then @renderEvents
    @model.fetchSubscribedUsers().then @renderUsers
      
  renderUsers: =>
    for user in @model.get('users')
      @$("#organization-users-list").append( @userTemplate( user: user ))
        
  render: ->
    $(@el).html(@template( @model.toJSON() ))
    $("li a[data-id='#{@model.id}']").parent().addClass 'selected'
    return this
