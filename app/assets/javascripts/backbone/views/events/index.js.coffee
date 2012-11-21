Gandalf.Views.Events ||= {}

class Gandalf.Views.Events.Index extends Backbone.View
  template: JST["backbone/templates/events/index"]

  id: "index"

  initialize: ->
    Gandalf.currentUser.fetchSubscribedOrganizations().then @renderSubscribedOrganizations
    Gandalf.currentUser.fetchSubscribedCategories().then @renderSubscribedCategories

  renderWeekCalendar: (days, startDate) ->
    view = new Gandalf.Views.Events.CalendarWeek()
    @$("#calendar-container").append(view.render(moment(startDate)).el)
    dayCount = 0
    while dayCount < 7
      d = moment(startDate).add('d', dayCount).format("YYYY-MM-DD")
      @addCalDay(days[d])
      dayCount++

  addCalDay: (events) ->
    view = new Gandalf.Views.Events.CalendarDay()
    @$("#cal-day-container").append(view.render(events).el)

  renderFeed: (days) ->
    _.each days, (events, day) =>
      @addFeedDay(day, events)

  addFeedDay: (day, events) ->
    view = new Gandalf.Views.Events.FeedDay()
    @$("#feed-list").append(view.render(day, events).el)

  sortAndGroupEvents: (events) ->
    sortedEvents = _.sortBy(events, (e)->
      t = moment(e.attributes.start_at)
      return t
    )
    groupedEvents = _.groupBy(sortedEvents, (event) ->
      return event.get('date')
    )
    groupedEvents

  findEventOverlaps: (days) ->
    overlaps = {}
    t = this
    _.each days, (events) ->
      if events.length > 1
        _.each events, (myE) ->
          myAttrs = myE.attributes
          _.each events, (targetE) ->
            tarAttrs = targetE.attributes
            if myAttrs.id < tarAttrs.id # && t.overlap(myAttrs, tarAttrs)
              id = myAttrs.id
              overlaps[id] ||= []
              overlaps[id].push tarAttrs.id

    @adjustOverlappingEvents overlaps

  # Doesn't work becuase jQuery selectors aren't working properly...
  adjustOverlappingEvents: (overlaps) ->
    _.each overlaps, (ids, myId) ->
      len = ids.length
      
      $(".cal-event[data_id='"+myId+"']").addClass("overlap-"+len).addClass("overlap-order-"+0)
      i = 1
      while i < len + 1
        id = ids[i-1]
        $(".cal-event[data_id='"+id+"']").addClass("overlap-"+len).addClass("overlap-order-"+i)
        i+=1

  
  # Find if two events overlap
  overlap: (e1, e2) ->
    one = moment(e1.start_at) < moment(e2.end_at)
    two = moment(e2.start_at) < moment(e1.end_at)
    console.log e1, e2
    console.log one, two
    one && two
    
  render: (events, start, period) ->
    $(@el).html(@template({user: Gandalf.currentUser}))
    
    days = @sortAndGroupEvents events.models

    @renderFeed(days)
    if period == "month"
      @renderMonthCalendar(days, moment(start))
    else 
      @renderWeekCalendar(days, moment(start))
    overlaps = @findEventOverlaps(days)
    console.log(overlaps)
    return this
    

  renderSubscribedOrganizations: ->
    subscriptions = Gandalf.currentUser.get('subscribed_organizations')
    _.each subscriptions, (subscription) ->
      view = new Gandalf.Views.Organizations.Short(model: subscription)
      @$("#subscribed-organizations-list").append(view.render().el)
  
  renderSubscribedCategories: ->
    subscriptions = Gandalf.currentUser.get('subscribed_categories')
    _.each subscriptions, (subscription) ->
      view = new Gandalf.Views.Categories.Short(model: subscription)
      @$("#subscribed-categories-list").append(view.render().el)
  
  events:
    'scroll' : 'scrolling'
  
  scrolling: ->
    console.log 'scrolling'
    if("#feed-list").scrollTop() + $(".feed").height() == $("#feed-list").height()
      console.log 'go!'
    