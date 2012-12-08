class Gandalf.Models.Event extends Backbone.Model
  paramRoot: 'event'

  defaults:
    name: null

  # Find if two events overlap
  overlap: (e) ->
    one = moment(@get("start_at")) < moment(e.get("end_at"))
    two = moment(e.get("start_at")) < moment(@get("end_at"))
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
    days = @sortAndGroup() 
    overlaps = {}
    for day,evs of days
      if evs.length > 1
        for myE in evs
          continue if @invisible(myE) 
          myId = myE.get("id")
          for targetE in evs
            continue if @invisible (targetE)
            tarId = targetE.get("id")
            if myId < tarId and myE.overlap(targetE)
              overlaps[myId] ||= []
              overlaps[myId].push tarId
    overlaps

  sortAndGroup: ()->
    sortedEvents = _.sortBy(@models, (e) ->
      time = moment(e.get("start_at")).sod()
      return time
    )
    groupedEvents = _.groupBy(sortedEvents, (e) ->
      # Gandalf.eventKeyFormat was set when the app was initialized
      return moment(e.get('start_at')).format(Gandalf.eventKeyFormat)
    )
    groupedEvents

  splitMultiDay: () ->
    for event in @models
      event.set(eventId: event.get("id"))
      start = event.get("start_at")
      end = event.get("end_at")
      diffDay = moment(end).diff(moment(start), 'days')
      diffHour = moment(end).diff(moment(start), 'hours')
      continue if diffDay is 0
      if diffDay is 1 and diffHour < 24
        # Don't save -- these changes should only be client side
        event.set
          end_at: moment(start).hours(23).minutes(59)
        newEvent = event.clone()
        newEvent.set
          start_at: moment(end).sod().format()
          end_at: end
          id: Math.random()
          eventId: event.get("id")
        @add(newEvent)
      else 
        console.log "Multi-day!"

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
