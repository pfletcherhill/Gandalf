# Backbone's representation of an Event.
# Author: Paul

class Gandalf.Models.Event extends Backbone.Model
  paramRoot: 'event'
  url: "/events"

  defaults:
    name: null
    start_at: null
    end_at: null
    organization_id: null
    description: null

  # Find if two events overlap.
  # param {Gandalf.Models.Event} e Another event object.
  # return {boolean} True if they overlap.
  overlap: (e) ->
    one = moment(@get("calStart")) < moment(e.get("calEnd"))
    two = moment(e.get("calStart")) < moment(@get("calEnd"))
    one and two

  # Get all the categoryIDs for this event.
  # return {Array.<string>} The ids.
  categoryIds: () ->
    arr = []
    for c in @get("categories")
      arr.push c.id
    arr

  # Make a comma-joined string of all category ids.
  # return {string} A string of the form "id1,id2,id3".
  makeCatIdString: () ->
    string = ""
    for c in @get("categories")
      string += (c.id + ",")
    string

  # An event's JSON representation, to be sent to the server.
  # NOTE(Rafi): This method must be updated whenever the event model
  #   is updated on the backend so fields are transferred.  
  toJSON: () ->
    {
      id: this.get("eventId")
      organization_id: this.get("organization_id")
      organization_slug: this.get("organization_slug")
      name: this.get("name")
      location: this.get("location")
      start_at: this.get("start_at")
      end_at: this.get("end_at")
      room_number: this.get("room_number")
      description: this.get("description")
      category_ids: this.get("category_ids")
      fb_id: this.get("fb_id")
    }

# Collections of Events.
class Gandalf.Collections.Events extends Backbone.Collection
  model: Gandalf.Models.Event
  url: '/events'

  # Constructor
  initialize: ->
    _.bindAll(this, "adjustOrganization", "adjustCategory")
    @hiddenOrgs = []
    @hiddenCats = []
    Gandalf.dispatcher.bind("categoryShort:click", @adjustCategory)
    Gandalf.dispatcher.bind("organizationShort:click", @adjustOrganization)

  # Finds all overlapping events in this collection.
  # Ignores hidden and multiday events.
  # return {Array.<Gandalf.Models.Event>} The array of all events that
  #   overlap with at least one other event.
  findOverlaps: () ->
    days = @group() 
    # console.log "days", days
    overlaps = {}
    for day,evs of days
      if evs.length > 1
        for myE in evs
          continue if @invisible(myE) or myE.get("multiday")
          myId = myE.get("id")
          for targetE in evs
            continue if @invisible(targetE) or targetE.get("multiday")
            tarId = targetE.get("id")
            if myId < tarId and myE.overlap(targetE)
              overlaps[myId] ||= []
              overlaps[myId].push tarId
    # console.log "olap" ,overlaps
    overlaps

  # Sorts and groups this collection's events by day.
  # return {(Gandalf.eventKeyFormat): Array.<Event>} An object where each key
  #   is the day represented in Gandalf.eventKeyFormat and the property 
  #   is the array of events for that day.
  group: ()->
    sorted = _.sortBy(@models, (e) ->
      return e.get("calStart")
    )
    grouped = _.groupBy(sorted, (e) ->
      # Gandalf.eventKeyFormat was set when the app was initialized
      return moment(e.get("calStart")).format(Gandalf.eventKeyFormat)
    )
    grouped

  # Gets all events that are multiday: i.e. span more than 24 hours.
  # return {Array.<Events>} The events.
  getMultidayEvents: () ->
    events = _.filter(@models, (e) ->
      e.get("multiday")
    )
    events 

  # Marks those events that are longer than 24 hours as multiday events.
  # If specified, also splits the events which span a date boundary into
  # separate events. 
  # NOTE(Rafi): Don't save in this method; these changes should only be 
  # client side.
  # param {boolean} splitMultidayEvents If true, split the events into multiple
  #   events with the same eventId, but different ids. 
  #   This option is used in for rendering the month view.
  splitMultiday: (splitMultidayEvents) ->
    for event in @models
      start = event.get("start_at")
      end = event.get("end_at")
      diffDay = moment(end).day() - moment(start).day()
      diffHour = moment(end).diff(moment(start), 'hours')
      continue if diffDay is 0                        # Normal event
      if diffHour >= 24 # At least one whole cycle
        event.set({ multiday: true }) 
        continue if not splitMultidayEvents

      event.set({ calEnd: moment(start).eod().format() })
      for i in [1..diffDay] # 1, 2, ... diffDay
        newEvent = event.clone()
        eventStart = moment(start).add('d', i).sod()
        if i is diffDay # Last day of event
          eventEnd = moment(end)
        else
          eventEnd = moment(eventStart).eod()
        newEvent.set
          calStart: eventStart.format()
          calEnd: eventEnd.format()
          id: event.get("id") + Math.random() # So it can be added to the collection
          eventId: event.get("id")
        @add(newEvent)

    
  # Check if an event is invisible.
  # param {Gandalf.Models.Event} e
  # return {boolean} True if not hidden.
  invisible: (e) ->
    orgHidden = @hiddenOrgs.indexOf(e.get("organization_id")) isnt -1
    catHidden = _.intersection(@hiddenCats, e.categoryIds()).length > 0
    return orgHidden or catHidden

  # Get all the organizations which are currently hidden, most likely because
  # the user doesn't want to show their events.
  # return {Array.<Gandalf.Models.Organization>} The hidden orgs.
  getHiddenOrgs: () ->
    return @hiddenOrgs

  # Get all the categories which are currently hidden, most likely because
  # the user doesn't want to show their events.
  # return {Array.<Gandalf.Models.Category>} The hidden categories.
  getHiddenCats: () ->
    return @hiddenCats

  # Get all the events which are visible.
  # return {Array.<Gandalf.Models.Event>} The visible events.
  getVisibleModels: () ->
    _.filter @models, ((m) ->
      orgHidden = @hiddenOrgs.indexOf(m.get("organization_id")) isnt -1
      catHidden = _.intersection(@hiddenCats, m.categoryIds()).length > 0
      return not(orgHidden or catHidden)
    ), this

  # Sets an organization as visible if it was hidden, or hidden if it was
  # visible.
  adjustOrganization: (id) ->
    idIndex = @hiddenOrgs.indexOf(id)
    if idIndex is -1
      @hiddenOrgs.push(id)
    else
      @hiddenOrgs.splice(idIndex, 1)
    # Tells views/events/index to toggle the visibility 
    # of the relavent events (in the calendar and feed)
    Gandalf.dispatcher.trigger("eventVisibility:change")

  # Sets an category as visible if it was hidden, or hidden if it was
  # visible.
  adjustCategory: (id) ->
    idIndex = @hiddenCats.indexOf(id)
    if idIndex is -1
      @hiddenCats.push(id)
    else
      @hiddenCats.splice(idIndex, 1)
    Gandalf.dispatcher.trigger("eventVisibility:change")
