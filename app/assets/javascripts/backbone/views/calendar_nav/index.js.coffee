Gandalf.Views.Calendar ||= {}

class Gandalf.Views.CalendarNav extends Backbone.View

  initialize: ->
    @startDate = @options.startDate || moment()
    @root = @options.root || ""
    @multidayVisible = true
    if @options.period == "month"
      @renderMonthMenu()
    else
      @renderWeekMenu()

    return this

  template: JST["backbone/templates/calendar_nav/index"]
  className: "cal-nav"

  events:
    "click .toggle-multiday" : "toggleMultiday"

  renderMonthMenu: () ->
    thisMonth = moment(@startDate).day(6).date(1)
    thisT = thisMonth.format("MMMM YYYY")
    prevT = moment(thisMonth).subtract('M', 1).format(Gandalf.displayFormat)
    nextT = moment(thisMonth).add('M', 1).format(Gandalf.displayFormat)
    if moment().month() == thisMonth.month()
      otherT = 'today'
    else
      otherT = moment(@startDate).format(Gandalf.displayFormat)
    # Add to html
    @$el.html @template(
      today: "##{@root}/today/month"
      thisT: thisT
      prevLink: "##{@root}/#{prevT}/month"
      nextLink: "##{@root}/#{nextT}/month"
      otherLink: "##{@root}/#{otherT}/week"
    )
    @$(".month").addClass "disabled"

  renderWeekMenu: () ->
    startDate = @startDate
    endDate = moment(startDate).add('d', 6)
    thisT =  startDate.format("MMM D") + " - " + endDate.format("MMM D")
    thisT += ", " + endDate.format("YYYY")
    prevT = moment(startDate).subtract('w', 1).format(Gandalf.displayFormat)
    nextT = moment(startDate).add('w', 1).format(Gandalf.displayFormat)
    if moment().day(1).format("DD") == moment(@startDate).day(1).format("DD")
      otherT = moment().date(1).format(Gandalf.displayFormat)
    else
      otherT = moment(startDate).date(1).format(Gandalf.displayFormat)

    @$el.html @template(
      today: "##{@root}/today/week"
      thisT: thisT
      prevLink: "##{@root}/#{prevT}/week"
      nextLink: "##{@root}/#{nextT}/week"
      otherLink: "##{@root}/#{otherT}/month"
    )
    @$(".week").addClass 'disabled'


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

