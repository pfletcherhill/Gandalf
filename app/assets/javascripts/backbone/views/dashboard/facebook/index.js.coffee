Gandalf.Views.Dashboard ||= {}

class Gandalf.Views.Dashboard.Facebook extends Backbone.View

  template: JST["backbone/templates/dashboard/facebook/index"]
  showTemplate: JST["backbone/templates/dashboard/facebook/show"]
  
  className: 'dash-org-container'

  initialize: ->
    @user = Gandalf.currentUser
    @render()
    @model.on("change", @render, this)

  events:
    "click .associate": "associate"

  render: ->
    @$el.html(@template(
      name: @model.get('name')
      fb_name: @model.get('fb_name')
      fb_link: @model.get('fb_link')
    ))
    @user.fetchFacebookOrganizations( =>
      @renderOrgs()
    )

  renderOrgs: ->
    orgs = @user.get('fb_accounts')
    console.log orgs
    if not orgs or not orgs.length
      @$("#dash-facebook-orgs").html(
        "<p><b>You're not the admin of any Facebook accounts. Nothing to do here :-/</b></p>")
    else
      for org in orgs
        @$("#dash-facebook-orgs").append(@showTemplate(org: org))

  associate: (e) ->
    o_id = $(e.target).data("id")
    FB.api("/#{o_id}", (data) =>
      @model.url = "/organizations/#{@model.get('id')}"
      @model.save(
        fb_id: o_id
        fb_name: data.name
        fb_link: data.link
      )
    )