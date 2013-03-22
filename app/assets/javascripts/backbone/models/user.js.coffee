class Gandalf.Models.User extends Backbone.Model
  paramRoot: 'user'

  defaults:
    name: null
    email: null

  fetchSubscribedOrganizations: ->
    $.ajax
      type: 'GET'
      dataType: 'json'
      url: '/users/' + @id + '/subscribed_organizations'
      success: (data) =>
        organizations = new Gandalf.Collections.Organizations
        organizations.add data
        @set subscribed_organizations: organizations

  fetchSubscribedCategories: ->
    $.ajax
      type: 'GET'
      dataType: 'json'
      url: '/users/' + @id + '/subscribed_categories'
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
      url: "/users/#{@id}/follow/organization/#{oid}"
      success: (data) =>
        console.log data
        this.get('subscribed_organizations').add data
        Gandalf.dispatcher.trigger("flash:success", 
          "Now following #{data.name}!")

  unfollowOrg: (oid) ->
    # type = o.constructor.name.toLowerCase()
    $.ajax
      type: 'POST'
      dataType: 'json'
      url: "/users/#{@id}/unfollow/organization/#{oid}"
      success: (data) =>
        console.log data
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
      url: "/users/#{@id}/follow/category/#{cid}"
      success: (data) =>
        this.get('subscribed_categories').add data
        Gandalf.dispatcher.trigger("flash:success", 
          "Now following #{data.name}!")

  unfollowCat: (cid) ->
    $.ajax
      type: 'POST'
      dataType: 'json'
      url: "/users/#{@id}/unfollow/category/#{cid}"
      success: (data) =>
        this.get('subscribed_categories').remove data
        Gandalf.dispatcher.trigger("flash:notice", 
          "No longer following #{data.name}")

  updateBulletinPreference: (value) ->
    @set(bulletin_preference: value)
    $.ajax
      type: 'POST'
      dataType: 'json'
      url: "users/#{@id}/bulletin_preference"
      data: 
        value: value
      success: (data) =>
        Gandalf.dispatcher.trigger("flash:success", 
          "You'll now get bulletin updates #{value}.")
  updateFacebook: (id, token) ->
    console.log "updating facebook with", id, token
    $.post('/me/facebook', {
        fb_id: id
        fb_access_token: token
      }, (user) ->
        Gandalf.currentUser = user
        console.log user
        Gandalf.dispatcher.trigger("flash:success", "Successfully logged into Facebook!")
    )

class Gandalf.Collections.Users extends Backbone.Collection
  model: Gandalf.Models.User
  url: '/users'
