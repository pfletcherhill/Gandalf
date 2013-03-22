class Gandalf.Views.CalendarPopover extends Gandalf.Views.Popover

  initialize: ->
    super()

    Gandalf.dispatcher.on("event:click", @showEvent, this)
    Gandalf.dispatcher.on("facebook:login", @showFacebookLogin, this)

  showEventTemplate: JST["backbone/templates/popover/events/show"]
  facebookTemplate: JST["backbone/templates/popover/facebook"]

  events:
    "click .global-overlay,.close,a" : "hide"
    "click .facebook" : "facebookLogin"

  showFacebookLogin: ->
    $(".gandalf-popover").html @facebookTemplate()
    console.log "prompting facebook login...", $(".gandalf-popover")
    @show()

  facebookLogin: ->
    FB.login (response) ->
      if response.authResponse
        Gandalf.facebookStatus = 'connected';
        Gandalf.facebookResponse = response.authResponse;
        console.log "Connected! saving..."
        Gandalf.currentUser.updateFacebook(
          response.authResponse.userID, response.authResponse.accessToken)
      else
        Gandalf.facebookStatus = 'not_connected';

  # Events event handlers
  showEvent: (object) ->
    model = object.model
    color = object.color
    eId = model.get("eventId")
    if model.get("id") isnt eId
      model = @myEvents.get(eId)
    $(".gandalf-popover").html @showEventTemplate(e: model, color: color)
    @show()
    @makeGMap(model)
    if /calendar/.test window.location.hash
      @makeWhyEventIsShown(model) 
    else
      $(".why").hide()

  # Helpers

  makeGMap: (model) ->
    myPos = new google.maps.LatLng(model.get("lat"), model.get("lon"))
    options =
      center: myPos
      zoom: 15
      mapTypeId: google.maps.MapTypeId.ROADMAP
    map = new google.maps.Map(document.getElementById("map-canvas"), options)
    marker = new google.maps.Marker(
      position: myPos
      map: map
      title: "Here it is!"
    )

  makeWhyEventIsShown: (model) ->
    following_org_ids = 
      Gandalf.currentUser.get("subscribed_organizations").pluck "id"
    following_cat_ids = 
      Gandalf.currentUser.get("subscribed_categories").pluck "id"
    model_org_id  = model.get("organization_id")
    model_cat_ids = _.pluck(model.get("categories"), "id")
    matching_cats = _.intersection(model_cat_ids, following_cat_ids)
    why = "#{model.get('name')} shows on your calendar because you're following "
    if model.get("organization_id") in following_org_ids
      why += "the sponsoring organization "
      why += "<a href='#/organizations/#{model_org_id}'>#{model.get("organization")}</a>"
      why += " and " if not _.isEmpty(matching_cats)
    if not _.isEmpty(matching_cats)
      if matching_cats.length is 1 then why += "the category " 
      else 
        why += "the categories "
      first = true
      for cat_id in matching_cats
        if not first
          why += ", "
        else
          first = false
        cat = Gandalf.currentUser.get("subscribed_categories").get(cat_id)
        why += "<a href='#/categories/#{cat_id}'>#{cat.get('name')}</a>"
    why += "."
    $(".why").popover
      html: true
      placement: "bottom"
      trigger: "click"
      title: "Why is this on my calendar?"
      content: why

    # console.log "SHOW:", model.get("organization_id")
    # console.log _.pluck(model.get("categories"), "id")
    # console.log Gandalf.currentUser.get("subscribed_organizations").pluck "id"
    # console.log Gandalf.currentUser.get("subscribed_categories").pluck "id"