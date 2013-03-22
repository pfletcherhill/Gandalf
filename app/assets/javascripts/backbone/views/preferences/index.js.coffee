Gandalf.Views.Preferences ||= {}

class Gandalf.Views.Preferences.Index extends Backbone.View
  template: JST["backbone/templates/preferences/index"]
  subscriptionTemplate: JST["backbone/templates/preferences/subscription"]

  initialize: ->
    @type = @options.type
    @pref = Gandalf.currentUser.get("bulletin_preference") 
    @render()

  events:
    "click .unfollow": "unfollow"
    "click .follow": "follow"
    "click .pref-email": "bulletinPreference"

  render: =>
    @$el.html @template(pref: @pref)
    @getSubscriptions() if @type is "subscriptions"
    @changeActive @type
    return this

  changeActive: (type) ->
    @$("li[data-type=#{type}]").addClass 'selected'

  getSubscriptions: =>
    @subscriptions = new Gandalf.Collections.Subscriptions
    @subscriptions.url = '/users/' + Gandalf.currentUser.id + '/subscriptions'
    @subscriptions.fetch success: (subscriptions) =>
      @subscriptions = subscriptions
      for subscription in @subscriptions.models
        if subscription.get('subscribeable_type') is 'Category'
          url = "#categories/" + subscription.get('subscribeable_id')
        else
          url = "#organizations/" + subscription.get('subscribeable_id')
        @$("#pref-subscriptions-tbody")
          .append(@subscriptionTemplate(url: url, sub: subscription.toJSON()))

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

  bulletinPreference: (e) ->
    Gandalf.currentUser.updateBulletinPreference $(e.target).val()