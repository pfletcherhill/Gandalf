class Gandalf.Router extends Backbone.Router
  
  initialize: (options) ->
    @events = new Gandalf.Collections.Events
    @organizations = new Gandalf.Collections.Organizations
    @organizations.add Gandalf.currentUser.get('organizations')
    view = new Gandalf.Views.Popover
    $(".wrapper").append view.el
  
  # Process period takes the date and period 
  # (either week or month, from the URL) and finds the start and end of the period
  # Returns an object with the parameters
  processPeriod: (date, period) ->
    if date == 'today'
      date = moment().format(Gandalf.displayFormat)
    if period == 'week'
      startAt = moment(date, Gandalf.displayFormat).day(0)
      endAt = moment(startAt).add('w',1)
    else if period == 'month'
      # Start at the Sunday before the first
      startAt = moment(date, Gandalf.displayFormat).date(1).day(0)
      # And go for 5 weeks
      endAt = moment(startAt).add('w', 5)
    else
      startAt = moment().day(0)
      endAt = moment(startAt).add('w',1)
      period = 'week'
    params = {
      start: startAt.sod()
      end: endAt.sod()
      period: period
    }
    params
  
  # Process params and generate params string
  generateParamsString: (params) ->
    paramsString = "start_at=" + params.start.format(Gandalf.displayFormat) 
    paramsString += "&end_at=" + params.end.format(Gandalf.displayFormat)
    paramsString
  
  showLoader: (selector) ->
    $(selector).html("<div class='loader'></div>")
          
  routes:
    # Browse Routes
    'browse/:type'                    : 'browse'          
    'browse*'                         : 'browse'
    
    # Calendar Routes
    'calendar/:date/:period'          : 'calendar'
    'calendar'                        : 'calendarRedirect'
    'calendar/:date'                  : 'calendarRedirect'
    
    # Dashboard Routes
    'dashboard'                       : 'dashboard'
    'dashboard/:id'                   : 'dashboard'
    'dashboard/:id/:type'             : 'dashboard'
    
    # Events Routes
    'events/:id'                      : 'events'
    'events*'                         : 'events'
    
    # Organization Routes
    'organizations/:id'               : 'organizations'
    'organizations*'                  : 'organizations'
  
    # Category Routes
    'categories/:id'                  : 'categories'
    'categories*'                     : 'categories'
    
    # Preferences Routes
    'preferences/:type'               : 'preferences'
    'preferences*'                    : 'preferences'
    
    # Static Routes
    'about'                           : 'about'
    '.*'                              : 'calendarRedirect'
  
  calendar: (date, period) ->
    @showLoader('#content')
    params = @processPeriod date, period
    string = @generateParamsString params
    @events.url = '/users/' + Gandalf.currentUser.id + '/events?' + string
    @events.fetch success: (events) ->
      view = new Gandalf.Views.Feed.Index(
        events: events
        startDate: params.start
        period: params.period
      )

  calendarRedirect: (date) ->
    date = "today" if not date
    @navigate("calendar/#{date}/week", {trigger: true, replace: true});
  
  browse: (type) ->
    @showLoader('.content-main')  
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
      view = new Gandalf.Views.Browse.Index(results: results, type: type)
      $("#content").html(view.el)
  
  dashboard: (id, type) ->
    id = @organizations.first().id unless id
    type = 'events' unless type is 'settings' or type is 'users'
    @organization = new Gandalf.Models.Organization
    @organization.url = "/organizations/#{id}/edit"
    @organization.fetch
      success: (organization) =>
        view = new Gandalf.Views.Dashboard.Index(
          organizations: @organizations
          organization: organization
          type: type
        )
      error: ->
        alert 'You do not have access to this organization.'
        window.location = "#organizations"
  
  events: (id) ->
    @event = new Gandalf.Models.Event
    @event.url = "/events/" + id
    @event.fetch
      success: (event) =>
        view = new Gandalf.Views.Events.Show( model: event )
    
  organizations: (id) ->
    params = @processPeriod 'today', 'week'
    @string = @generateParamsString params
    @organization = new Gandalf.Models.Organization
    @organization.url = "/organizations/" + id
    @organization.fetch
      success: (organization) =>
        view = new Gandalf.Views.Organizations.Show(
          model: organization,
          string: @string,
          startDate: params.start,
          period: params.period
        )
  
  categories: (id) ->
    params = @processPeriod 'today', 'week'
    @string = @generateParamsString params
    @category = new Gandalf.Models.Category
    @category.url = "/categories/" + id
    @category.fetch
      success: (category) =>
        view = new Gandalf.Views.Categories.Show(
          model: category,
          string: @string
          startDate: params.start,
          period: params.period
        )

  # preferences tab with subscriptions and account info
  preferences: (type) ->
    @showLoader('.content-main')  
    $(".left-list a").removeClass 'active'
    if type == 'account'
      view = new Gandalf.Views.Preferences.Index(type: type)
      $("#content").html(view.el)
    else
      type = "subscriptions"
      @subscriptions = new Gandalf.Collections.Subscriptions
      @subscriptions.url = '/users/' + Gandalf.currentUser.id + '/subscriptions'
      @subscriptions.fetch success: (subscriptions) =>
        view = new Gandalf.Views.Preferences.Index(type: type, subscriptions: subscriptions)
        $("#content").html(view.el)
  
  # about page
  about: ->
    view = new Gandalf.Views.Static.About
    $("#content").html(view.render().el)
