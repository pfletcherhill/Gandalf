Gandalf.Views.Dashboard ||= {}

class Gandalf.Views.Dashboard.Users extends Backbone.View
  
  template: JST["backbone/templates/dashboard/users/index"]
  
  className: 'dash-org-container'

  events:
    "click .select-all" : "selectAll"
    "click .deselect-all" : "deselectAll"
    "click #email-subscribers-btn" : "email"
    
  initialize: =>
    @render()
    @model.fetchEvents().then @renderEvents
    @model.fetchSubscribedUsers().then @renderUsers
      
  renderUsers: =>
    for user, index in @model.get('users')
      view = new Gandalf.Views.Dashboard.User(model: user, index: index)
      @$(".dash-list-body").append view.el
        
  render: ->
    @$el.html @template(@model.toJSON())
    $("li[data-id='#{@model.id}']").addClass 'selected'
    return this

  # Event handlers

  selectAll: ->
    $("[type='checkbox']").attr "checked", "checked"
    $(".select-all")
      .text("Deselect all")
      .removeClass("select-all")
      .addClass("deselect-all")
    false

  deselectAll: ->
    $("[type='checkbox']").removeAttr "checked"
    $(".deselect-all")
      .text("Select all")
      .removeClass("deselect-all")
      .addClass("select-all")
    false

  email: ->
    emails = []
    inputs = $("[checked='checked']")
    return false if inputs.length is 0
    for input in inputs
      index = $(input).attr "data-index"
      user = @model.get('users')[index]
      emails.push user.email

    to = "mailto:#{emails.join(",")}"
    $("#email-subscribers-btn").attr "href", to
    true

