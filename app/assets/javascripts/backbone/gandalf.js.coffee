#= require_self
#= require_tree ./templates
#= require_tree ./models
#= require_tree ./views
#= require_tree ./routers

window.Gandalf =
  Models: {}
  Collections: {}
  Routers: {}
  Views: {}
  # Why use two different formats..?
  eventKeyFormat: "YYYY-MM-DD"
  displayFormat: "MM-DD-YYYY"
  hourHeight: 30
  # Canonical date string. Supports Yesterday, Today, Tomorrow, Last <day of week> and
  # <day of week> to note the next such day.
  # Defaults to a sttring like 'Sunday, March 1'.
  # param {Moment} date The moment() object to format.
  # return {string} The formatted date string.
  formatDate: (date) ->
    today = moment()
    diff = date.sod().diff today.sod(), 'days'
    string = switch
      when diff < -1 and diff > -7 then 'Last ' + date.format 'dddd'
      when diff is -1 then 'Yesterday'
      when diff is 0 then 'Today'
      when diff is 1 then 'Tomorrow'
      when diff > 1 and diff < 7 then date.format 'dddd'
      else date.format 'dddd, MMMM D'
    string

  # Formats time. Yay.
  formatTime: (time) ->
    time.format 'h:mm a'
  dispatcher: _.clone(Backbone.Events)

window.onresize = (e) ->
  Gandalf.dispatcher.trigger("window:resize")
