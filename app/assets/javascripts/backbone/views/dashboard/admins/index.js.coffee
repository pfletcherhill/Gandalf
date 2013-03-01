Gandalf.Views.Dashboard ||= {}

class Gandalf.Views.Dashboard.Admins extends Backbone.View
  
  template: JST["backbone/templates/dashboard/users/index"]
  
  className: 'dash-org-container'
    
  initialize: =>
    @render()
    @model.fetchAdmins().then @renderAdmins
    Gandalf.dispatcher.bind("dashboard:user:checkbox", @updateSelect, this)

  # Add users to table   
  renderAdmins: => 
    for user, index in @model.get('admins')
      # Create view for each user
      view = new Gandalf.Views.Dashboard.User(model: user, index: index)
      @$(".dash-list-body").append view.el
    @updateSelect()

  render: ->
    @$el.html @template(typeName: "Administrators")
    $("li[data-id='#{@model.id}']").addClass 'selected'
    return this