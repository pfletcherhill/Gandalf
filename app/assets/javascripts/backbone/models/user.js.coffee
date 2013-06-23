class Gandalf.Models.User extends Backbone.Model
  paramRoot: 'user'

  defaults:
    name: null
    email: null

  fetchSubscribedOrganizations: ->
    $.ajax
      type: 'GET'
      dataType: 'json'
      url: '/users/subscribed_organizations'
      success: (data) =>
        organizations = new Gandalf.Collections.Organizations
        organizations.add data
        @set subscribed_organizations: organizations

  fetchSubscribedCategories: ->
    $.ajax
      type: 'GET'
      dataType: 'json'
      url: '/users/subscribed_categories'
      success: (data) =>
        categories = new Gandalf.Collections.Categories
        categories.add data
        @set subscribed_categories: categories

  isFollowing: (model, collection) ->
    collection = 'subscribed_organizations' unless collection
    for mod in this.get(collection).models
      return true if mod.id is model.id     # Found the model!
    return false

  followOrg: (oid) ->
    # We cannot use the constructor because when assets are compiled,
    # all model names are assigned to a random letter (in our case, 'r').
    # That's why we were getting the URL as /users/2/follow/r/1 or
    # something like that. NASTY BUG!!!
    # type = o.constructor.name.toLowerCase()
    $.ajax
      type: 'POST'
      dataType: 'json'
      url: "/users/follow/organization/#{oid}"
      success: (data) =>
        this.get('subscribed_organizations').add data
        Gandalf.dispatcher.trigger("flash:success", 
          "Now following #{data.name}!")

  unfollowOrg: (oid) ->
    # type = o.constructor.name.toLowerCase()
    $.ajax
      type: 'POST'
      dataType: 'json'
      url: "/users/unfollow/organization/#{oid}"
      success: (data) =>
        this.get('subscribed_organizations').remove data
        Gandalf.dispatcher.trigger("flash:notice", 
          "No longer following #{data.name}")

  followCat: (cid) ->
    # We cannot use this because when assets are compiled, all model names are assigned
    # to a random letter (in our case, 'r'). That's why we were getting the URL as
    # /users/2/follow/r/1 or something. NASTY BUG!!!
    # type = o.constructor.name.toLowerCase()
    $.ajax
      type: 'POST'
      dataType: 'json'
      url: "/users/follow/category/#{cid}"
      success: (data) =>
        this.get('subscribed_categories').add data
        Gandalf.dispatcher.trigger("flash:success", 
          "Now following #{data.name}!")

  unfollowCat: (cid) ->
    $.ajax
      type: 'POST'
      dataType: 'json'
      url: "/users/unfollow/category/#{cid}"
      success: (data) =>
        this.get('subscribed_categories').remove data
        Gandalf.dispatcher.trigger("flash:notice", 
          "No longer following #{data.name}")

  updateBulletinPreference: (value) ->
    @set(bulletin_preference: value)
    $.ajax
      type: 'POST'
      dataType: 'json'
      url: "users/bulletin_preference"
      data: 
        value: value
      success: (data) =>
        Gandalf.dispatcher.trigger("flash:success", 
          "You'll now get bulletin updates #{value}.")

  updateFacebook: (f_id, f_token) ->
    Gandalf.currentUser.url = "/me"
    Gandalf.currentUser.set
      fb_id: f_id 
      fb_access_token: f_token
    Gandalf.currentUser.save(
      fb_id: f_id 
      fb_access_token: f_token
    , success: (user) ->
        # console.log "the current user", user
        Gandalf.dispatcher.trigger("flash:success", "Successfully logged into Facebook!")
      error: (user) ->
        console.log "the error user", user
        Gandalf.dispatcher.trigger("flash:error", "Mismatching users...")
    )

  fetchFacebookOrganizations: (cb) ->
    access_token = Gandalf.currentUser.get('fb_access_token')
    FB.api("/me/accounts?access_token=#{access_token}", (data) =>
      @set('fb_accounts', data.data)
      @save()
      cb() if typeof cb is "function"
    )

  asJSON: =>
    return _.omit @attributes, [
      'organizations'
      'subscribed_categories'
      'subscribed_organizations'
    ]

class Gandalf.Collections.Users extends Backbone.Collection
  model: Gandalf.Models.User
  url: '/users'
