Gandalf.Views.Dashboard ||= {}

class Gandalf.Views.Dashboard.Users extends Backbone.View
  
  template: JST["backbone/templates/dashboard/users/index"]
  
  className: 'dash-org-container'
    
  initialize: =>
    @render()
    @model.fetchSubscribedUsers().then @renderUsers
    Gandalf.dispatcher.bind("dashboard:user:checkbox", @updateSelect, this)
  
  # Add users to table   
  renderUsers: => 
    for user, index in @model.get('users')
      # Create view for each user
      view = new Gandalf.Views.Dashboard.User(model: user, index: index)
      @$(".dash-list-body").append view.el
    @updateSelect()
        
  render: ->
    @$el.html @template(typeName: "Subscribers")
    $("li[data-id='#{@model.id}']").addClass 'selected'
    return this

  # Event handlers
  events:
    "click .select-all" : "selectAll"
    "click .deselect-all" : "deselectAll"
    "click #email-subscribers-btn" : "email"

  updateSelect: ->
    checked = $(":checked").length
    numUsers = @model.get('users').length
    $(".dash-list-count").text("Selected #{checked} of #{numUsers} users")
    if(checked < numUsers)
      $(".deselect-all")
        .text("Select all")
        .removeClass("deselect-all")
        .addClass("select-all")
    else
      $(".select-all")
        .text("Deselect all")
        .removeClass("select-all")
        .addClass("deselect-all")
        
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
    ids = []
    inputs = $("[checked='checked']")
    return false if inputs.length is 0
    for input in inputs
      index = $(input).attr "data-index"
      user = @model.get('users')[index]
      ids.push user.id
    # 
    # to = "mailto:#{emails.join(",")}"
    # $("#email-subscribers-btn").attr "href", to
    # true
    Gandalf.dispatcher.trigger( "dashboard:email", {emails: ids, organization: @model} )