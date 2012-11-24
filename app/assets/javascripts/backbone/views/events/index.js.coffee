Gandalf.Views.Events ||= {}

class Gandalf.Views.Events.Index extends Backbone.View

  # options has keys [collection, startDate, period]
  initialize: ()->
    _.bindAll(this, "adjustOverlappingEvents")
    Gandalf.currentUser.fetchSubscribedOrganizations().then @renderSubscribedOrganizations
    Gandalf.currentUser.fetchSubscribedCategories().then @renderSubscribedCategories
    # Listening for global events
    Gandalf.dispatcher.bind("index:adjust", @adjustOverlappingEvents)
    # Class variables
    @startDate = @options.startDate
    @period = @options.period
    @maxOverlaps = 4

    @render()

  template: JST["backbone/templates/events/index"]
  calHeaderTemplate: JST["backbone/templates/events/calendar_header"]

  el: "#content"

  events: 
    "click #cal-next" : "next"
    "click #cal-prev" : "prev"
    "scroll" : "scrolling"

  renderWeekCalendar: () ->
    header = @calHeaderTemplate(startDate: @startDate)
    @$("#calendar-container").html(header)
    view = new Gandalf.Views.Events.CalendarWeek(startDate: moment(@startDate))
    @$("#calendar-container").append(view.el)

  renderMonthCalendar: () ->
    view = new Gandalf.Views.Events.CalendarWeek(startDate: moment(@startDate))
    @$("#calendar-container").html(view.el)

  renderCalDays: () ->
    dayCount = 0
    while dayCount < @numDays
      # Gandalf.eventKeyFormat was set when the app was initialized
      d = moment(@startDate).add('d', dayCount).format(Gandalf.eventKeyFormat)
      @addCalDay(@days[d])
      dayCount++

  addCalDay: (events) ->
    view = new Gandalf.Views.Events.CalendarDay(model: events)
    @$("#cal-day-container").append(view.el)

  renderFeed: () ->
    _.each @days, (events, day) =>
      @addFeedDay(day, events)

  addFeedDay: (day, events) ->
    view = new Gandalf.Views.Events.FeedDay(day: day, collection: events)
    @$("#feed-list").append(view.el)

  adjustOverlappingEvents: () ->
    overlaps = @collection.findOverlaps()
    $(".cal-event").removeClass("overlap-2 overlap-3 overlap-4")
    _.each overlaps, (ids, myId) ->
      num = ids.length + 1
      $(".cal-event[data-event-id='"+myId+"']").addClass "overlap overlap-"+num
      _.each ids, (id, i) ->
        $(".cal-event[data-event-id='"+id+"']").addClass "overlap overlap-"+num
    @makeCSSAdjustments()

  # CSS wasn't strong enough for the kind of styling I wanted to do...
  # so we're doing it in JS
  makeCSSAdjustments: () ->
    overlapIndex = 2
    pLeft = 3
    calZ = 10
    while overlapIndex <= @maxOverlaps
      evs = $(".cal-event.overlap-"+overlapIndex+":not(.event-hidden)")
      width = Math.floor(100/overlapIndex) - overlapIndex
      longWidth = width + pLeft
      $(evs).css({ width: width+"%", paddingLeft: pLeft+"%" })
      _.each evs, (e, index) ->
        if index%overlapIndex == 0
          $(e).css(
            left: 0
            paddingLeft: 0
            width: longWidth+"%"
          )
        else if index%overlapIndex == 1
          $(e).css(
            left: width+"%"
            zIndex: calZ - 1
          )
        else if index%overlapIndex == 2
          newWidth = width * 2
          $(e).css(
            left: newWidth+"%"
            zIndex: calZ - 2
          )
        else if index%overlapIndex == 3
          newWidth = width * 3
          $(e).css(
            left: newWidth+"%"
            zIndex: calZ - 3
          )
      overlapIndex++

# // 2 things overlapping
# $o_padding: 3%;
# .overlap-1 {
#   $width: 49%;
#   width: $width;
#   padding-left: $o_padding;
#   &:nth-of-type(2n+1) {
#     padding-left: 0;
#     width: $width + $o_padding;
#   }
#   &:nth-of-type(2n) {
#     left: $width;
#     z-index: $cal_z - 1;
#   }
# }
# // 3 things
# .overlap-2 {
#   $width: 31%;
#   width: $width;
#   padding-left: $o_padding;
#   &:nth-of-type(3n+1) {
#     padding-left: 0;
#     width: $width + $o_padding;
#   }
#   &:nth-of-type(3n+2) {
#     left: $width;
#     z-index: $cal_z - 1;
#   }
#   &:nth-of-type(3n) {
#     left: $width * 2;
#     z-index: $cal_z - 2;
#   }
# }
# // 4 things
# .overlap-3 {
#   $width: 22%;
#   width: $width;
#   padding-left: $o_padding;
#   &:nth-of-type(4n-3) {
#     padding-left: 0;
#     width: $width + $o_padding;
#   }
#   &:nth-of-type(4n-2) {
#     left: $width;
#     z-index: $cal_z - 1;
#   }
#   &:nth-of-type(4n-1) {
#     left: $width * 2;
#     z-index: $cal_z - 2;
#   }
#   &:nth-of-type(4n) {
#     left: $width * 3;
#     z-index: $cal_z - 3;
#   }
# }


  renderCalendar: () ->
    if @period == "month"
      @renderMonthCalendar()
      @numDays = 28 # ACTUALLy number of days in the month of moment(start)
    else 
      @renderWeekCalendar()
      @numDays = 7
    @renderCalDays()
    @adjustOverlappingEvents()

  render: () ->
    $(@el).html(@template({ user: Gandalf.currentUser }))
    @days = @collection.sortAndGroup()
    @renderFeed()
    @renderCalendar()

    return this
    

  renderSubscribedOrganizations: ->
    subscriptions = Gandalf.currentUser.get('subscribed_organizations')
    _.each subscriptions, (subscription) ->
      view = new Gandalf.Views.Organizations.Short(model: subscription)
      @$("#subscribed-organizations-list").append(view.el)
  
  renderSubscribedCategories: ->
    subscriptions = Gandalf.currentUser.get('subscribed_categories')
    _.each subscriptions, (subscription) ->
      view = new Gandalf.Views.Categories.Short(model: subscription)
      @$("#subscribed-categories-list").append(view.el)
  
  next: () ->
    @startDate.add('w', 1)
    @renderCalendar()

  prev: () ->
    @startDate.subtract('w', 1)
    @renderCalendar()

  # Paul, this code should be in 
  scrolling: ->
    if("#feed-list").scrollTop() + $(".feed").height() == $("#feed-list").height()
      console.log 'go!'
    