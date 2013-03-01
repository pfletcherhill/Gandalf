Gandalf.Views.Dashboard ||= {}

class Gandalf.Views.Dashboard.Admins extends Backbone.View
  
  template: JST["backbone/templates/dashboard/users/index"]
  
  className: 'dash-org-container'
    
  initialize: =>
    @render()
        
  render: =>
    @$el.html @template(@model.toJSON())
    $("li[data-id='#{@model.id}']").addClass 'selected'
    return this