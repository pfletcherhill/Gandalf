Gandalf.Views.Dashboard ||= {}

class Gandalf.Views.Dashboard.Users extends Backbone.View
  
  template: JST["backbone/templates/dashboard/users/index"]
  userTemplate: JST["backbone/templates/dashboard/users/show"]
  
  id: 'organization'
    
  initialize: =>
    @render()
    @model.fetchEvents().then @renderEvents
    @model.fetchSubscribedUsers().then @renderUsers
      
  renderUsers: =>
    for user in @model.get('users')
      @$("#organization-users-list").append( @userTemplate( user: user ))
        
  render: ->
    @$el.html @template(@model.toJSON())
    $("li[data-id='#{@model.id}']").addClass 'selected'
    return this
