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
        @set subscribed_organizations: data
  
  fetchSubscribedCategories: ->
    $.ajax
      type: 'GET'
      dataType: 'json'
      url: '/users/' + @id + '/subscribed_categories'
      success: (data) =>
        @set subscribed_categories: data

class Gandalf.Collections.Users extends Backbone.Collection
  model: Gandalf.Models.User
  url: '/users'
