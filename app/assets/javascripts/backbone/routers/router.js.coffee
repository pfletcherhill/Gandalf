class Gandalf.Router extends Backbone.Router
  
  initialize: (options) ->
    @events = new Gandalf.Collections.Events
    @organizations = new Gandalf.Collections.Organizations
    @organizations.add Gandalf.currentUser.get('organizations')
  
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
    params = {
      start: startAt
      end: endAt
      period: period
    }
    params
  
  # Process params and generate params string
  generateParamsString: (params) ->
    paramsString = "start_at=" + params.start.format("MM-DD-YYYY") 
    paramsString += "&end_at=" + params.end.format("MM-DD-YYYY")
    paramsString
        
  routes:
    'browse/:type'              : 'browse'          
    'browse*'                   : 'browse'
    'calendar/:date/:period'    : 'calendar'
    'calendar'                  : 'calendar'
    'organizations/:id'         : 'organizations'
    'organizations*'            : 'organizations'
    'preferences'               : 'preferences'
    'about'                     : 'about'
    '.*'                        : 'calendar'
  
  calendar: (date, period) ->
    params = @processPeriod date, period
    string = @generateParamsString params
    @events.url = '/users/' + Gandalf.currentUser.id + '/events?' + string
    @events.fetch success: (events) ->
      view = new Gandalf.Views.Events.Index
      $("#content").html(view.render(events, params.start, params.period).el)
  
  browse: (type) ->  
    $(".search-list a").removeClass 'active'
    if type == 'categories'
      @results = new Gandalf.Collections.Categories
      @results.url = '/categories'
    else if type == 'events'
      @results = new Gandalf.Collections.Events
      @results.url = '/events'
    else
      type = 'organizations'
      @results = new Gandalf.Collections.Organizations
      @results.url = '/organizations'
    @results.fetch success: (results) ->
      view = new Gandalf.Views.Events.Browse(results: results, type: type)
      $("#content").html(view.el)
  
  organizations: (id) ->
    id = @organizations.first().id unless id
    @organization = new Gandalf.Models.Organization
    @organization.url = "/organizations/" + id
    @organization.fetch success: (organization) =>
      view = new Gandalf.Views.Organizations.Index(organizations: @organizations, organization: organization)
    
  preferences: ->
    view = new Gandalf.Views.Users.Preferences
    $("#content").html(view.render().el)
  
  about: ->
    view = new Gandalf.Views.Static.About
    $("#content").html(view.render().el)
  
