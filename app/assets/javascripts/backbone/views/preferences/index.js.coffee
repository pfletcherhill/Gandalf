Gandalf.Views.Preferences ||= {}

class Gandalf.Views.Preferences.Index extends Backbone.View
  template: JST["backbone/templates/preferences/index"]
  subscriptionTemplate: JST["backbone/templates/preferences/subscription"]

  initialize: ->
    @type = @options.type
    @subscriptions = @options.subscriptions
    @render()

  events:
    "click .unfollow": "unfollow"
    "click .follow": "follow"

  render: =>
    $(@el).html(@template())
    @renderSubscriptions()
    @changeActive(@type)
    return this

  changeActive: (type) ->
    @$("li[data-type=#{type}]").addClass 'selected'

  renderSubscriptions: =>
    console.log @subscriptions, @subscriptions.models[0].toJSON()
    for subscription in @subscriptions.models
      if subscription.get('subscribeable_type') == 'Category'
        url = "#categories/" + subscription.get('subscribeable_id')
      else
        url = "#organizations/" + subscription.get('subscribeable_id')
      @$("tbody").append(@subscriptionTemplate(url: url, sub: subscription.toJSON()))

  unfollow: (e) ->
    id = $(e.target).attr "data-id"
    type = $(e.target).attr "data-type"
    if type is "Organization"
      Gandalf.currentUser.unfollowOrg(id)
    else if type is "Category"
      Gandalf.currentUser.unfollowCat(id)

    $(e.target).text("Re-follow").addClass("follow").removeClass("unfollow")

  follow: (e) ->
    id = $(e.target).attr "data-id"
    type = $(e.target).attr "data-type"
    if type is "Organization"
      Gandalf.currentUser.followOrg(id)
    else if type is "Category"
      Gandalf.currentUser.followCat(id)

    $(e.target).text("Unfollow").addClass("unfollow").removeClass("follow")