Gandalf.Views.Organizations ||= {}

class Gandalf.Views.Organizations.Show extends Backbone.View
  
  template: JST["backbone/templates/organizations/show"]
  
  el: '#content'
  
  initialize: ->
    @string = @options.string
    @render()
  
  renderFollowing: =>
    if Gandalf.currentUser.get('subscribed_organizations')
      if Gandalf.currentUser.isFollowing(@model, 'subscribed_organizations')
        $("button.follow").addClass 'following'
      else
        $("button.follow").attr 'class','follow'
    else
      Gandalf.currentUser.fetchSubscribedOrganizations().then @renderFollowing
  
  renderCategories: ->
    categories = @model.get('categories')
    cats = []
    if categories
      for category in categories
        cats.push "<a href='#categories/#{category.id}'>#{category.name}</a>"
      @$('.organization-categories').append( cats.join(', ') )
  
  renderEvents: =>
            
  render: ->
    $(@el).html(@template( organization: @model ))
    @renderCategories()
    @renderFollowing()
    @model.fetchEvents(@string).then @renderEvents
    return this
  
  events:
    "click .follow" : "follow"
  
  follow: (event) ->
    if $(event.target).hasClass 'following'
      Gandalf.currentUser.unfollow(@model).then @renderFollowing
    else
      Gandalf.currentUser.follow(@model).then @renderFollowing
    