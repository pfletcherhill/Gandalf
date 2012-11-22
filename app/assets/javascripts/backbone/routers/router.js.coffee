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
      startAt = moment(date, "MM-DD-YYYY").day(0)
      endAt = moment(startAt).add('w',1)
    else if period == 'month'
      startAt = moment(date, "MM-DD-YYYY").date(1)
      endAt = moment(startAt).add('M',1)
    else
      startAt = moment().day(0)
      endAt = moment(startAt).add('w',1)
      period = 'week'
    p = {
      start: startAt
      end: endAt
      period: period
    }
    p
      
  routes:
    'browse/:type'            : 'browse'          
    'browse*'                : 'browse'
    'calendar/:date/:period'  : 'calendar'
    'calendar'                : 'calendar'
    'organizations'           : 'organizations'
    'preferences'             : 'preferences'
    'about'                   : 'about'
    '.*'                      : 'calendar'
  
  calendar: (date, period) ->
    params = @processPeriod date, period
    paramsString = "start_at=" + params.start.format("MM-DD-YYYY") 
    paramsString += "&end_at=" + params.end.format("MM-DD-YYYY")

    @events.url = '/users/' + Gandalf.currentUser.id + '/events?' + paramsString

    @events.fetch success: (events) ->
      view = new Gandalf.Views.Events.Index
      $("#content").html(view.render(events, params.start, params.period).el)
  
  browse: (type) ->  
    if type == 'categories'
      @results = new Gandalf.Collections.Categories
      @results.url = '/categories'
    else if type == 'events'
      @results = new Gandalf.Collections.Events
      @results.url = '/events'
    else
      @results = new Gandalf.Collections.Organizations
      @results.url = '/organizations'
    @results.fetch success: (results) ->
      view = new Gandalf.Views.Events.Browse
      $("#content").html(view.render(results).el)
  
  organizations: ->
    view = new Gandalf.Views.Organizations.Index
    $("#content").html(view.render().el)
    
  preferences: ->
    view = new Gandalf.Views.Users.Preferences
    $("#content").html(view.render().el)
  
  about: ->
    view = new Gandalf.Views.Static.About
    $("#content").html(view.render().el)
  
