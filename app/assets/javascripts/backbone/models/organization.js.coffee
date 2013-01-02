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
        console.log "data", data
        myevents = new Gandalf.Collections.Events data
        console.log "before", myevents
        @set events: myevents
  
  fetchSubscribedUsers: ->
    $.ajax
      type: 'GET'
      dataType: 'json'
      url: '/organizations/' + @id + '/subscribed_users'
      success: (data) =>
        @set users: data
        
  asJSON: =>
    organization = _.clone this.attributes
    return _.extend organization, {image: this.get('image')}
    
class Gandalf.Collections.Organizations extends Backbone.Collection
  model: Gandalf.Models.Organization
  url: '/organizations'
