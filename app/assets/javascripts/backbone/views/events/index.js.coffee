Gandalf.Views.Events ||= {}

class Gandalf.Views.Events.Index extends Backbone.View
  template: JST["backbone/templates/events/index"]

  id: "index"

  initialize: ->
    Gandalf.currentUser.fetchSubscribedOrganizations().then @renderSubscribedOrganizations
    Gandalf.currentUser.fetchSubscribedCategories().then @renderSubscribedCategories

  renderWeekCalendar: (days, start_date) ->
    view = new Gandalf.Views.Events.CalendarWeek()
    @$("#calendar-container").append(view.render(moment(start_date)).el)
    day_count = 0
    while day_count < 7
      d = moment(start_date).add('d', day_count).format("YYYY-MM-DD")
      @addCalDay(days[d])
      day_count++

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
        _.each events, (my_e) ->
          my_attrs = my_e.attributes
          _.each events, (target_e) ->
            tar_attrs = target_e.attributes
            if my_attrs.id < tar_attrs.id # && t.overlap(my_attrs, tar_attrs)
              id = my_attrs.id
              overlaps[id] ||= []
              overlaps[id].push tar_attrs.id

    @adjustOverlappingEvents overlaps

  # Doesn't work becuase jQuery selectors aren't working properly...
  adjustOverlappingEvents: (overlaps) ->
    _.each overlaps, (ids, my_id) ->
      len = ids.length
      
      $(".cal-event[data_id='"+my_id+"']").addClass("overlap-"+len).addClass("overlap-order-"+0)
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
      @$("#subscribed_organizations_list").append(view.render().el)
  
  renderSubscribedCategories: ->
    subscriptions = Gandalf.currentUser.get('subscribed_categories')
    _.each subscriptions, (subscription) ->
      view = new Gandalf.Views.Categories.Short(model: subscription)
      @$("#subscribed_categories_list").append(view.render().el)
  
  events:
    'scroll' : 'scrolling'
  
  scrolling: ->
    console.log 'scrolling'
    if("#events_list").scrollTop() + $(".feed").height() == $("#events_list").height()
      console.log 'go!'
    