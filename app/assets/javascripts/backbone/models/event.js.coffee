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
    for event in days
      if events.length > 1
        for myE in events
          myId = myE.get("id")
          for targetE in events
            tarId = targetE.get("id")
            if myId < tarId and myE.overlap(targetE)
              overlaps[myId] ||= []
              overlaps[myId].push tarId
    overlaps

  sortAndGroup: ()->
    sortedEvents = _.sortBy(@getVisibleModels(), (e) ->
      time = moment(e.get("start_at"))
      return time
    )
    groupedEvents = _.groupBy(sortedEvents, (e) ->
      # Gandalf.eventKeyFormat was set when the app was initialized
      return moment(e.get('start_at')).format(Gandalf.eventKeyFormat)
    )
    groupedEvents

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
      state = "hide"
    else
      @hiddenOrgs.splice(idIndex, 1)
      state = "show"
    # Tells views/events/calendar_event to toggle the visibility 
    # of the relavent events
    Gandalf.dispatcher.trigger("eventVisibility:change", {
      id: id, state: state, kind: "organization"
    })

  adjustCategory: (id) ->
    idIndex = @hiddenCats.indexOf(id)
    if idIndex is -1
      @hiddenCats.push(id)
      state = "hide"
    else
      @hiddenCats.splice(idIndex, 1)
      state = "show"
    Gandalf.dispatcher.trigger("eventVisibility:change", {
      id: id, state: state, kind: "category"
    })