window.utilities =
  # Why use two different formats..?
  eventKeyFormat: "YYYY-MM-DD"
  displayFormat: "MM-DD-YYYY"
  hourHeight: 30
  # Canonical date string. Supports Yesterday, Today, Tomorrow, Last <day of week> and
  # <day of week> to note the next such day.
  # Defaults to a sttring like 'Sunday, March 1'.
  # param {Moment} date The moment() object to format.
  # param {boolean} lowercase True if the canonical should be lower case
  # return {string} The formatted date string.
  formatDate: (date, lowercase=false) ->
    today = moment()
    diff = date.sod().diff today.sod(), 'days'
    string = switch
      when diff < -1 and diff > -7 then 'Last ' + date.format 'dddd'
      when diff is -1 
        if lowercase then 'yesterday' else 'Yesterday'
      when diff is 0 
        if lowercase then 'today' else 'Today'
      when diff is 1 
        if lowercase then 'tomorrow' else 'Tomorrow'
      when diff > 1 and diff < 7 then date.format 'dddd'
      else date.format 'dddd, MMMM D'
    string

  # Formats time. Yay.
  formatTime: (time) ->
    time.format 'h:mm a'
  
  capitalizeString: (string) ->
    string.charAt(0).toUpperCase() + string.slice(1)
    
  dispatcher: _.clone(Backbone.Events)

window.onresize = (e) ->
  Gandalf.dispatcher.trigger("window:resize")
