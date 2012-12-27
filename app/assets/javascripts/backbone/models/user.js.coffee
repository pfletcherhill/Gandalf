class Gandalf.Models.User extends Backbone.Model
  paramRoot: 'user'

  defaults:
    name: null
    email: null
  
  # I think this should be fetchSubscriptions, where the returned json includes
  # the subscribeable. We would then parse the that into subscribed_organizations
  # and subscribed_categories by checking each subscribeable's subscribeable_type
  # That way, it's one less ajax request.

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
        @set subscribed_categories: data
  
  isFollowing: (organization) ->
    subscribed = []
    for org in this.get('subscribed_organizations').models
      subscribed.push(org.id)
    if _.contains(subscribed, organization.id)
      true
    else
      false
  
  follow: (organization) ->
    $.ajax
      type: 'POST'
      dataType: 'json'
      url: '/users/' + @id + '/follow/organization/' + organization.id
      success: (data) =>
        this.get('subscribed_organizations').add data
  
  unfollow: (organization) ->
    $.ajax
      type: 'POST'
      dataType: 'json'
      url: '/users/' + @id + '/unfollow/organization/' + organization.id
      success: (data) =>
        this.get('subscribed_organizations').remove data

class Gandalf.Collections.Users extends Backbone.Collection
  model: Gandalf.Models.User
  url: '/users'
