class Gandalf.Router extends Backbone.Router
  
  initialize: (options) ->
    @events = new Gandalf.Collections.Events
  
  # Process period takes the date and period 
  # (either week or month, from the URL) and finds the start and end of the period
  # Returns an object with the parameters
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
      period = 'week'
    p = {
      start: start_at
      end: end_at
      period: period
    }
    p
      
  routes:
    'browse'                  : 'browse'
    'calendar/:date/:period'  : 'calendar'
    'calendar'                : 'calendar'
    'organizations'           : 'organizations'
    'preferences'             : 'preferences'
    'about'                   : 'about'
    '.*'                      : 'calendar'
  
  calendar: (date, period) ->
    params = @processPeriod date, period
    params_string = "start_at=" + params.start.format("MM-DD-YYYY") 
    params_string += "&end_at=" + params.end.format("MM-DD-YYYY")

    @events.url = '/users/' + Gandalf.currentUser.id + '/events?' + params_string

    @events.fetch success: (events) ->
      view = new Gandalf.Views.Events.Index
      $("#content").html(view.render(events, params.start, params.period).el)
  
  browse: ->
    @events.url = '/events'
    @events.fetch success: (events) ->
      view = new Gandalf.Views.Events.Browse
      $("#content").html(view.render().el)
  
  organizations: ->
    view = new Gandalf.Views.Organizations.Index
    $("#content").html(view.render().el)
    
  preferences: ->
    view = new Gandalf.Views.Users.Preferences
    $("#content").html(view.render().el)
  
  about: ->
    view = new Gandalf.Views.Static.About
    $("#content").html(view.render().el)
  
