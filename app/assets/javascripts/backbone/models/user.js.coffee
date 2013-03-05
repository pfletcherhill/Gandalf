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

  follow: (o) ->
    console.log o
    type = o.constructor.name.toLowerCase()
    $.ajax
      type: 'POST'
      dataType: 'json'
      url: '/users/' + @id + '/follow/' + type + '/' + o.id
      success: (data) =>
        if type == 'organization'
          this.get('subscribed_organizations').add data
        else if type == 'category'
          this.get('subscribed_categories').add data

  unfollow: (o) ->
    console.log o
    type = o.constructor.name.toLowerCase()
    $.ajax
      type: 'POST'
      dataType: 'json'
      url: '/users/' + @id + '/unfollow/' + type + '/' + o.id
      success: (data) =>
        if type == 'organization'
          this.get('subscribed_organizations').remove data
        else if type == 'category'
          this.get('subscribed_categories').remove data

class Gandalf.Collections.Users extends Backbone.Collection
  model: Gandalf.Models.User
  url: '/users'
