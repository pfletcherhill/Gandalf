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
    subscribed = []
    for mod in this.get(collection).models
      subscribed.push(mod.id)
    if _.contains(subscribed, model.id)
      true
    else
      false

  followOrg: (o) ->
    console.log o
    # We cannot use this because when assets are compiled, all model names are assigned
    # to a random letter (in our case, 'r'). That's why we were getting the URL as
    # /users/2/follow/r/1 or something like that. NASTY BUG!!!
    # type = o.constructor.name.toLowerCase()
    $.ajax
      type: 'POST'
      dataType: 'json'
      url: '/users/' + @id + '/follow/organization/' + o.id
      success: (data) =>
        this.get('subscribed_organizations').add data

  unfollowOrg: (o) ->
    # type = o.constructor.name.toLowerCase()
    $.ajax
      type: 'POST'
      dataType: 'json'
      url: '/users/' + @id + '/unfollow/organization/' + o.id
      success: (data) =>
        this.get('subscribed_organizations').remove data

  followCat: (o) ->
    # We cannot use this because when assets are compiled, all model names are assigned
    # to a random letter (in our case, 'r'). That's why we were getting the URL as
    # /users/2/follow/r/1 or something. NASTY BUG!!!
    # type = o.constructor.name.toLowerCase()
    $.ajax
      type: 'POST'
      dataType: 'json'
      url: '/users/' + @id + '/follow/category/' + o.id
      success: (data) =>
        this.get('subscribed_categories').add data

  unfollowCat: (o) ->
    $.ajax
      type: 'POST'
      dataType: 'json'
      url: '/users/' + @id + '/unfollow/category/' + o.id
      success: (data) =>
        this.get('subscribed_categories').remove data

class Gandalf.Collections.Users extends Backbone.Collection
  model: Gandalf.Models.User
  url: '/users'
