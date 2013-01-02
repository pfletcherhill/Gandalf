Gandalf.Views.Categories ||= {}

class Gandalf.Views.Categories.Show extends Backbone.View
  
  template: JST["backbone/templates/categories/show"]
  
  el: '#content'
  
  initialize: ->
    @string = @options.string
    @render()
  
  renderFollowing: =>
    if Gandalf.currentUser.get('subscribed_categories')
      if Gandalf.currentUser.isFollowing(@model, 'subscribed_categories')
        $("button.follow").addClass 'following'
      else
        $("button.follow").attr 'class','follow'
    else
      Gandalf.currentUser.fetchSubscribedCategories().then @renderFollowing
  
  renderEvents: =>
            
  render: ->
    $(@el).html(@template( category: @model ))
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