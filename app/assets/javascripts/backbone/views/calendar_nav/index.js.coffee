Gandalf.Views.Calendar ||= {}

class Gandalf.Views.CalendarNav extends Backbone.View

  initialize: ->
    @startDate = @options.startDate || moment()
    @root = @options.root || ""
    @multidayVisible = true
    @type = @options.type
    switch @type
      when "month" then @renderMonthMenu()
      when "week" then @enderWeekMenu()
      else @renderDayMenu()

    return this

  template: JST["backbone/templates/calendar_nav/index"]
  className: "cal-nav"

  events:
    "click .toggle-multiday" : "toggleMultiday"

  renderMonthMenu: ->
    thisMonth = moment(@startDate).day(6).date(1)
    thisT = thisMonth.format("MMMM YYYY")
    prevT = moment(thisMonth).subtract('M', 1).format(Gandalf.displayFormat)
    nextT = moment(thisMonth).add('M', 1).format(Gandalf.displayFormat)
    if moment().month() == thisMonth.month()
      otherT = 'today'
    else
      otherT = moment(@startDate).format(Gandalf.displayFormat)
    @render(
      prevT: prevT
      nextT: nextT
      thisT: thisT
      otherT: otherT
    , "month")

  renderWeekMenu: ->
    startDate = @startDate
    endDate = moment(startDate).add('d', 6)
    thisT =  startDate.format("MMM D") + " - " + endDate.format("MMM D")
    thisT += ", " + endDate.format("YYYY")
    prevT = moment(startDate).subtract('w', 1).format(Gandalf.displayFormat)
    nextT = moment(startDate).add('w', 1).format(Gandalf.displayFormat)
    if moment().day(1).format("DD") == moment(@startDate).day(1).format("DD")
      otherT = 'today'
    else
      otherT = moment(startDate).date(1).format(Gandalf.displayFormat)
    @render(
      prevT: prevT
      nextT: nextT
      thisT: thisT
      otherT: otherT
    , "week")

  renderDayMenu: ->
    startDate = @startDate
    endDate = moment(startDate).add('d', 1)
    thisT = startDate.format('DD, MMM YYYY')
    prevT = moment(startDate).subtract('d', 1).format(Gandalf.displayFormat)
    nextT = moment(startDate).add('d', 1).format(Gandalf.displayFormat)
    if moment(startDate).sod() == moment().sod() 
      otherT = 'today'
    else
      otherT = startDate.format(Gandalf.displayFormat)
    @render(
      prevT: prevT
      nextT: nextT
      thisT: thisT
      otherT: otherT
    , "list")

  # Renders the final calendar nav.
  # param {Object} links An object with the following string parameters
  #   (all in Gandalf.displayFormat):
  #   thisT: The current date range string eg. "July 6 - July 13, 2013"
  #   prevT: The previous time period
  #   nextT: The next time period
  #   dayT:  The time for the day view link
  #   weekT: The time for the week view link
  #   monthT:  The time for the month view link

  render: (links) ->
    @$el.html @template(
      today: "##{@root}/today"
      thisT: links.thisT
      prevLink: "##{@root}/#{links.prevT}/#{@type}"
      nextLink: "##{@root}/#{links.nextT}/#{@type}"
      dayLink: "##{@root}/#{links.otherT}"
      weekLink: "##{@root}/#{links.otherT}/week"
      monthLink: "##{@root}/#{links.otherT}/month"
    )
    @$(".#{@type}").removeClass 'disabled'

  # Event handlers

  toggleMultiday: ->
    @$(".toggle-multiday > i")
      .toggleClass("icon-eye-close")
      .toggleClass("icon-eye-open")
    if @multidayVisible
      Gandalf.dispatcher.trigger("multiday:hide")
    else
      Gandalf.dispatcher.trigger("multiday:show")
    @multidayVisible = not @multidayVisible
###
