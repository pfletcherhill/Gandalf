class Gandalf.Models.Event extends Backbone.Model
  paramRoot: 'event'

  defaults:
    name: null

  # Find if two events overlap
  overlap: (e) ->
    one = moment(@get("start_at")) < moment(e.get("end_at"))
    two = moment(e.get("start_at")) < moment(@get("end_at"))
    # console.log one, two
    one && two

class Gandalf.Collections.Events extends Backbone.Collection
  model: Gandalf.Models.Event
  url: '/events'

  initialize: ->
    _.bindAll(@)

  findOverlaps: (days) ->
    # days = @sortAndGroup
    overlaps = {}
    t = this
    _.each days, (events) ->
      if events.length > 1
        _.each events, (myE) ->
          myId = myE.get("id")
          _.each events, (targetE) ->
            tarId = targetE.get("id")
            if myId < tarId && myE.overlap(targetE)
              overlaps[myId] ||= []
              overlaps[myId].push tarId
    overlaps


  sortAndGroup: ()->
    sortedEvents = _.sortBy(@models, (e)->
      time = moment(e.get("start_at"))
      return time
    )
    groupedEvents = _.groupBy(sortedEvents, (e) ->
      # Using start_at now because the event.to_json in the ruby wasn't
      # properly converting between timezones
      # Gandalf.eventKeyFormat was set when the app was initialized
      return moment(e.get('start_at')).format(Gandalf.eventKeyFormat)
    )
    groupedEvents
