class Gandalf.Models.Event extends Backbone.Model
  paramRoot: 'event'

  defaults:
    name: null
    start_at: null
    end_at: null
    organization_id: null
    description: null

  # Find if two events overlap
  overlap: (e) ->
    one = moment(@get("calStart")) < moment(e.get("calEnd"))
    two = moment(e.get("calStart")) < moment(@get("calEnd"))
    one and two

  categoryIds: () ->
    arr = []
    for c in @get("categories")
      arr.push c.id
    arr

  makeCatIdString: () ->
    string = ""
    for c in @get("categories")
      string += (c.id + ",")
    string

class Gandalf.Collections.Events extends Backbone.Collection
  model: Gandalf.Models.Event
  url: '/events'

  initialize: ->
    _.bindAll(this, "adjustOrganization", "adjustCategory")
    @hiddenOrgs = []
    @hiddenCats = []
    Gandalf.dispatcher.bind("categoryShort:click", @adjustCategory)
    Gandalf.dispatcher.bind("organizationShort:click", @adjustOrganization)

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

  group: ()->
    sorted = _.sortBy(@models, (e) ->
      return e.get("calStart")
    )
    grouped = _.groupBy(sorted, (e) ->
      # Gandalf.eventKeyFormat was set when the app was initialized
      return moment(e.get("calStart")).format(Gandalf.eventKeyFormat)
    )
    grouped

  getMultidayEvents: () ->
    events = _.filter(@models, (e) ->
      e.get("multiday")
    )
    events 

  # Don't save in this method -- these changes should only be client side
  # If splitMultidayEvents is true, then 
  splitMultiDay: (splitMultidayEvents) ->
    for event in @models
      start = event.get("start_at")
      end = event.get("end_at")
      diffDay = moment(end).diff(moment(start), 'days')
      diffHour = moment(end).diff(moment(start), 'hours')
      continue if diffDay is 0                        # Normal event
      if diffHour >= 24 # At least one whole cycle
        # event.set({ multiday: true }) 
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

    

  invisible: (e) ->
    orgHidden = @hiddenOrgs.indexOf(e.get("organization_id")) isnt -1
    catHidden = _.intersection(@hiddenCats, e.categoryIds()).length > 0
    return orgHidden or catHidden

  getHiddenOrgs: () ->
    return @hiddenOrgs

  getHiddenCats: () ->
    return @hiddenCats

  getVisibleModels: () ->
    _.filter @models, ((m) ->
      orgHidden = @hiddenOrgs.indexOf(m.get("organization_id")) isnt -1
      catHidden = _.intersection(@hiddenCats, m.categoryIds()).length > 0
      return not(orgHidden or catHidden)
    ), this

  adjustOrganization: (id) ->
    idIndex = @hiddenOrgs.indexOf(id)
    if idIndex is -1
      @hiddenOrgs.push(id)
    else
      @hiddenOrgs.splice(idIndex, 1)
    # Tells views/events/index to toggle the visibility 
    # of the relavent events (in the calendar and feed)
    Gandalf.dispatcher.trigger("eventVisibility:change")

  adjustCategory: (id) ->
    idIndex = @hiddenCats.indexOf(id)
    if idIndex is -1
      @hiddenCats.push(id)
    else
      @hiddenCats.splice(idIndex, 1)
    Gandalf.dispatcher.trigger("eventVisibility:change")
