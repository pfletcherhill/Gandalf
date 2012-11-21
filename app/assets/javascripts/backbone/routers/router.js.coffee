class Gandalf.Router extends Backbone.Router
  
  initialize: (options) ->
    @events = new Gandalf.Collections.Events
  
  processPeriod: (date, period) ->
    if date == 'today'
      date = moment().format("MM-DD-YYYY")
    if period == 'week'
      start_at = moment(date, "MM-DD-YYYY").day(0)
      end_at = moment(start_at).add('w',1)
    else if period == 'month'
      start_at = moment(date, "MM-DD-YYYY").date(1)
      end_at = moment(start_at).add('M',1)
    else
      start_at = moment()
      end_at = moment().add('w',1)
    params = "start_at=" + start_at.format("MM-DD-YYYY") + "&end_at=" + end_at.format("MM-DD-YYYY")
    params  
      
  routes:
    'browse'                  : 'browse'
    'calendar/:date/:period'  : 'calendar'
    'calendar'                : 'calendar'
    'preferences'             : 'preferences'
    'about'                   : 'about'
    '.*'                      : 'calendar'
  
  calendar: (date, period) ->
    params = @processPeriod date, period
    @events.url = '/users/' + Gandalf.currentUser.id + '/events?' + params
    @events.fetch success: (events) ->
      view = new Gandalf.Views.Events.Index
      $("#events").html(view.render(events).el)
  
  browse: ->
    @events.url = '/events'
    @events.fetch success: (events) ->
      view = new Gandalf.Views.Events.Browse
      $("#events").html(view.render().el)
    
  preferences: ->
    view = new Gandalf.Views.Users.Preferences
    $("#events").html(view.render().el)
  
  about: ->
    view = new Gandalf.Views.Static.About
    $("#events").html(view.render().el)
  
