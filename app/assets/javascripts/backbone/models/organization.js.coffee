class Gandalf.Models.Organization extends Backbone.Model
  paramRoot: 'organization'

  defaults:
    name: null
  
  fetchEvents: (string) ->
    if string
      string = '?' + string
    else
      string = ''
    $.ajax
      type: 'GET'
      dataType: 'json'
      url: '/organizations/' + @id + '/events' + string
      success: (data) =>
        orgEvents = new Gandalf.Collections.Events data
        @set events: orgEvents
  
  fetchSubscribedUsers: ->
    $.ajax
      type: 'GET'
      dataType: 'json'
      url: '/organizations/' + @id + '/subscribed_users'
      success: (data) =>
        @set users: data
  
  fetchAdmins: ->
    $.ajax
      type: 'GET'
      dataType: 'json'
      url: '/organizations/' + @id + '/admins'
      success: (data) =>
        @set admins: data
        
  asJSON: =>
    organization = _.clone this.attributes
    return _.extend organization, {image: this.get('image')}
    
class Gandalf.Collections.Organizations extends Backbone.Collection
  model: Gandalf.Models.Organization
  url: '/organizations'
