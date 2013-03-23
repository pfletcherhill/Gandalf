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

  syncFBEvents: ->
    access_token = Gandalf.currentUser.get('fb_access_token')
    params = "access_token=#{access_token}&fields=access_token,app_id,name,events,picture"
    FB.api("/#{@get('fb_id')}?#{params}", (data) =>
      if data.events
        Gandalf.dispatcher.trigger("organization:fbSyncEvents", 
          events: data.events.data
          organization: this
        )
      else
        Gandalf.dispatcher.trigger("flash:error", "Couldn't get Facebook events for this organization...")
    )
    console.log "Fetching Facebook events..."

  addFBEvents: (events) ->
    count = events.length
    counter = 0
    for e in events
      e.end_time ||= moment(e.start_time).add('h', 1).format()
      console.log e.end_time
      newE = new Gandalf.Models.Event
      newE.save {
          name: e.name
          fb_id: e.id
          location: e.location
          start_at: e.start_time
          end_at: e.end_time
          organization_id: @get('id')
          category_ids: []
          description: ""
        }, { 
          success: (e) ->
            console.log "fb event created!", e
            counter++
            if counter is count
              Gandalf.dispatcher.trigger("flash:success", "Facebook events synced!")
          error: () ->
            count--
            alert("We couldn't create event '#{e.name}'. Perhaps it's already synced?")
            Gandalf.dispatcher.trigger("flash:error", "Error creating #{e.name}.")
        }

        
  asJSON: =>
    organization = _.clone this.attributes
    return _.extend organization, {image: this.get('image')}
    
class Gandalf.Collections.Organizations extends Backbone.Collection
  model: Gandalf.Models.Organization
  url: '/organizations'
