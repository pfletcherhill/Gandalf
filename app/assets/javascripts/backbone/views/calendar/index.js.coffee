Gandalf.Views.Calendar ||= {}

class Gandalf.Views.Calendar.Index extends Backbone.View

  initialize: ->
    split = true #(@options.type is "week")
    console.log "split", split
    @collection.splitMultiDay(split)       # Adjust multi-day events
    @days = @collection.group()
    # Class variables
    @startDate = @options.startDate
    @maxOverlaps = 4                  # Maximum allowed event overlaps
    # Listening for global events
    Gandalf.dispatcher.bind("eventVisibility:change", @hideHidden, this)
    Gandalf.dispatcher.bind("window:resize", @resetEventPositions, this)
    @render()

  className: "calendar"
  popoverTemplate: JST["backbone/templates/calendar/popover"]

  render: ->
    if @options.type is "month"
      @$el.append(@renderMonth().el)
    else 
      @$el.append(@renderWeek().el)
      # @renderWeekMultiday()
      @adjustOverlappingEvents()
    t = this
    setInterval( ->
      t.resetEventPositions()
    , 20000)


  renderWeek: ->
    view = new Gandalf.Views.Calendar.Week.Index(
      startDate: moment(@startDate)
      days: @days
    )
    return view

  renderMonth: () ->
    view = new Gandalf.Views.Calendar.Month.Index(
      startDate: moment(@startDate)
      days: @days
    )
    return view
    # @hideHidden()

  # So far unused...
  renderWeekMultiday: () ->
    evs = @collection.getMultidayEvents()
    for event in evs
      view = new Gandalf.Views.Calendar.Week.Multiday(
        { model: event, startDate: moment(@startDate) }
      )
      $(".cal-multiday").append(view.el)

  # Event handlers

  hideHidden: () ->
    orgs = @collection.getHiddenOrgs()
    cats = @collection.getHiddenCats()
    @orgVisChange(orgs)
    @catVisChange(cats)

  resetEventPositions: () ->
    @$el.find(".cal-week-event").css({ width: "96%" }) # For window resizing
    @makeCSSAdjustments()


  # Helpers

  adjustOverlappingEvents: () ->
    # If an event overlaps with one other, they both get class 'overlap-2', etc. for 3, 4
    overlaps = @collection.findOverlaps()
    @$el.find(".cal-week-event").removeClass("overlap-2 overlap-3 overlap-4 hide")
    for myId, ids of overlaps
      num = ids.length + 1
      num = @maxOverlaps if num > @maxOverlaps
      @$el.find(".cal-week-event[data-event-id='#{myId}']").addClass "overlap-#{num}"
      count = 0
      for id in ids
        @$el.find(".cal-week-event[data-event-id='#{id}']").addClass "overlap-#{num}"
        count++
    @makeCSSAdjustments()

  # CSS wasn't strong enough for the kind of styling I wanted to do...
  # so we're doing it in JS
  # Cost: 21 * number of events
  makeCSSAdjustments: () ->
    calZ = 10
    for i in [0...7]
      for overlapIndex in [2..@maxOverlaps]
        width = Math.floor(98/overlapIndex)
        selector = ".cal-week-event.overlap-#{overlapIndex}.day-#{i}"
        selector += ":not(.hide, .event-hidden-org, .event-hidden-cat)"
        evs = @$el.find(selector)
        $(evs).css({ width: "#{width}%"})
        for e, index in evs
          num = index%overlapIndex
          $(e).css(
            left: "#{width*num}%"
            zIndex: calZ - num
          )

  orgVisChange: (hiddenOrgs) ->
    $(".js-event").removeClass("event-hidden-org")
    for orgId in hiddenOrgs
      $(".js-event[data-organization-id='#{orgId}']").addClass "event-hidden-org"
    @adjustOverlappingEvents()

  catVisChange: (hiddenCats) ->
    $(".js-event").removeClass("event-hidden-cat")
    for catId in hiddenCats
      id = catId+","
      $(".js-event[data-category-ids*='#{id}']").addClass "event-hidden-cat"
    @adjustOverlappingEvents()

  
