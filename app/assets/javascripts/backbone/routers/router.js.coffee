class Gandalf.Router extends Backbone.Router

  initialize: (options) ->
    # Set Global Gandalf.currentUser
    Gandalf.currentUser = new Gandalf.Models.User(options.currentUser)
    
    #Initialize @events and @organizations
    @events = new Gandalf.Collections.Events
    @organizations = new Gandalf.Collections.Organizations(Gandalf.currentUser.get('organizations'))
    window.orgs = @organizations
    #@popover = new Gandalf.Views.Popover
    @flash = new Gandalf.Views.Flash
    $(".wrapper").append @flash.el

    # Load user data
    Gandalf.currentUser.fetchSubscribedOrganizations()
    Gandalf.currentUser.fetchSubscribedCategories()

    # Constants
    Gandalf.constants ||= {}
    Gandalf.constants.allCategories = new Gandalf.Collections.Categories
    Gandalf.constants.allCategories.fetch()

    # Set global AJAX error
    $(document).ajaxError ->
      Gandalf.dispatcher.trigger("flash:error", 
        "Oh no! Looks like we got an error. Please try again later :-/")

  # Takes the date and type (list (aka today), week or month)
  # and finds the start and end of the period specified by the type.
  # param {string} date The date to get the period for.
  # param {string} type One of [list, week, month]
  # return {{start: moment(), end: moment(), type: type}} 
  #   an object with the parameters.
  processType: (date, type) ->
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
      period = 'list'
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

    # Dashboard Routes
    'dashboard'                       : 'dashboard'
    'dashboard/:slug'                 : 'dashboard'
    'dashboard/:slug/:type'           : 'dashboard'

    # Events Routes
    'events/:id'                      : 'events'
    'events*'                         : 'events'

    # Organization Routes
    'organizations/:slug'             : 'organizations'
    'organizations/:slug/:date/:period' : 'organizations'
    'organizations*'                  : 'organizations'

    # Category Routes
    'categories/:slug'                : 'categories'
    'categories/:slug/:date/:period'  : 'categories'
    'categories*'                     : 'categories'

    # Preferences Routes
    'preferences/:type'               : 'preferences'
    'preferences*'                    : 'preferences'

    # Static Routes
    'about'                           : 'about'

    # Calendar Routes (catch all)
    ':date'                           : 'calendar'
    ':date/:type'                     : 'calendar'
    '.*'                              : 'calendar'

  next: (type) ->
    console.log 'next'

  calendar: (date, type) ->
    @showLoader('#content')
    date ||= 'today'
    type ||= 'list'
    params = @processPeriod date, type
    string = @generateParamsString params
    @events.url = '/users/events?' + string
    @events.fetch success: (events) ->
      view = new Gandalf.Views.Feed.Index(
        events: events
        startDate: params.start
        period: params.period
      )
      Gandalf.dispatcher.trigger("popover:eventsReady", events)
    @popover = new Gandalf.Views.CalendarPopover
    $("#popover").html @popover.el

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

  dashboard: (slug, type) ->
    slug ||= @organizations.first().get('slug')
    id = @organizations.where(slug: slug)[0].id
    type ||= 'events'
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
    @popover = new Gandalf.Views.DashboardPopover
    $("#popover").html @popover.el

  events: (id) ->
    @event = new Gandalf.Models.Event
    @event.url = "/events/" + id
    @event.fetch
      success: (event) =>
        view = new Gandalf.Views.Events.Show( model: event )

  organizations: (slug, date, period) ->
    if not period or not date
      @navigate("organizations/#{slug}/today/week", {trigger: true, replace: true});
    params = @processPeriod date, period
    @string = @generateParamsString params
    @organization = new Gandalf.Models.Organization
    @organization.url = "/organizations/slug/" + slug
    @organization.fetch
      success: (organization) =>
        view = new Gandalf.Views.Organizations.Show(
          model: organization,
          string: @string,
          startDate: params.start,
          period: params.period
        )

  categories: (slug, date, period) ->
    if not period or not date
      @navigate("categories/#{slug}/today/week", {trigger: true, replace: true});
    params = @processPeriod date, period
    @string = @generateParamsString params
    @category = new Gandalf.Models.Category
    @category.url = "/categories/slug/" + slug
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
    # if type == 'account'
    type ||= "subscriptions"
    view = new Gandalf.Views.Preferences.Index(type: type)
    $("#content").html(view.el)
    # else
    #   type = "subscriptions"
    #   @subscriptions = new Gandalf.Collections.Subscriptions
    #   @subscriptions.url = '/users/' + Gandalf.currentUser.id + '/subscriptions'
    #   @subscriptions.fetch success: (subscriptions) =>
    #     view = new Gandalf.Views.Preferences.Index(type: type, subscriptions: subscriptions)
    #     $("#content").html(view.el)

  # about page
  about: ->
    view = new Gandalf.Views.Static.About
    $("#content").html(view.render().el)
