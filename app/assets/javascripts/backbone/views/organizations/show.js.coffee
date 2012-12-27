Gandalf.Views.Organizations ||= {}

class Gandalf.Views.Organizations.Show extends Backbone.View
  
  template: JST["backbone/templates/organizations/show/show"]
  calendarBody: JST["backbone/templates/organizations/show/org_calendar_week"]
  calendarDay: JST["backbone/templates/organizations/show/org_calendar_week_day"]
  
  el: '#content'
  
  initialize: ->
    @string = @options.string
    @render()
  
  renderFollowing: =>
    if Gandalf.currentUser.get('subscribed_organizations')
      if Gandalf.currentUser.isFollowing(@model)
        console.log 'following'
        $("button.follow").text "Following"
        $("button.follow").addClass 'following'
      else
        console.log 'not following'
        $("button.follow").text "Follow"
        $("button.follow").attr 'class','follow'
    else
      Gandalf.currentUser.fetchSubscribedOrganizations().then @renderFollowing
    
  renderCalendar: ->
    @$(".content-calendar").html(@calendarBody())
    for i in [1..7]
      @$("tr.cal-day-container").append(@calendarDay())
  
  renderCategories: ->
    categories = @model.get('categories')
    cats = []
    if categories
      for category in categories
        cats.push "<a href='#categories/#{category.id}'>#{category.name}</a>"
      @$('.organization-categories').append( cats.join(', ') )
  
  renderEvents: =>
    console.log 'render'
    console.log @model
            
  render: ->
    $(@el).html(@template( organization: @model ))
    @renderCategories()
    @renderCalendar()
    @renderFollowing()
    @model.fetchEvents(@string).then @renderEvents
    return this
  
  events:
    "mouseover .following" : "onHoverFollowing"
    "mouseout .following" : "offHoverFollowing"
    "click .follow" : "follow"
  
  onHoverFollowing: (event) ->
    $(".following").html 'Unfollow'
    $(".following").addClass 'unfollow'
  
  offHoverFollowing: (event) ->
    $(".following").html 'Following'
    $(".following").removeClass 'unfollow'
  
  follow: (event) ->
    if $(event.target).hasClass 'following'
      Gandalf.currentUser.unfollow(@model).then @renderFollowing
    else
      Gandalf.currentUser.follow(@model).then @renderFollowing
    