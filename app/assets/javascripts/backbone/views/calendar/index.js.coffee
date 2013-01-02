Gandalf.Views.Calendar ||= {}

class Gandalf.Views.Calendar.Index extends Backbone.View

  initialize: ->
    split = (@options.type is "month")
    @collection.splitMultiDay(split)       # Adjust multi-day events
    @days = @collection.group()
    # Class variables
    @startDate = @options.startDate
    @maxOverlaps = 4                  # Maximum allowed event overlaps
    # Listening for global events
    Gandalf.dispatcher.bind("eventVisibility:change", @hideHidden, this)
    Gandalf.dispatcher.bind("window:resize", @resetEventPositions, this)
    Gandalf.dispatcher.on("event:click", @eventClick, this)
    @render()

  className: "calendar"

  render: ->
    if @options.type is "month"
      @$el.append(@renderMonth().el)
    else 
      @$el.append(@renderWeek().el)
      # @renderWeekMultiday()
      @adjustOverlappingEvents()

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
    $(".cal-week-event").css({ width: "96%" }) # For window resizing
    @makeCSSAdjustments()

  eventClick: (e) ->
    @showPopover(e.model, e.color)

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

  showPopover: (model, color) ->
    popover = $(".cal-popover")
    calDayWidth = $(".cal-body .cal-day").width()
    mDay = moment(model.get("calStart")).day()

    left = right = "auto"
    # Comment this if else block and uncomment the next to see moving popups
    if mDay < 3
      right = "10px"
    else
      left = "10px"
    # if mDay < 3
    #   left = (mDay+1) * calDayWidth + 60
    # else
    #   right = ((7-mDay) * calDayWidth) + 20

    eId = model.get("eventId")
    if model.get("id") isnt eId
      model = @collection.get(eId)
    $(popover)
      .css(
        left: left
        right: right
      ).html(@popoverTemplate(e: model, color: color))
      .fadeIn("fast")
    $(".cal-popover .close").click(() ->
      $(this).parents(".cal-popover").fadeOut("fast")
    )
    @makeGMap(model)

  makeGMap: (model) ->
    myPos = new google.maps.LatLng(model.get("lat"), model.get("lon"))
    options = 
      center: myPos
      zoom: 15
      mapTypeId: google.maps.MapTypeId.ROADMAP
    map = new google.maps.Map(document.getElementById("map-canvas"), options)
    marker = new google.maps.Marker(
      position: myPos
      map: map
      title: "Here it is!"
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

  
