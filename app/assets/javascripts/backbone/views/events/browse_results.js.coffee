Gandalf.Views.Events ||= {}

class Gandalf.Views.Events.BrowseResult extends Backbone.View
  
  organizationTemplate: JST["backbone/templates/organizations/browse/browse_result"]
  eventTemplate: JST["backbone/templates/events/browse/browse_result"]
  categoryTemplate: JST["backbone/templates/categories/browse/browse_result"]
  
  className: "browse-result"
  
  initialize: ->
    @type = @options.type
  
  convertTime: (time) ->
    moment(time).format("MMMM DD, h:mm a")

  renderCategories: ->
    categories = @model.get('categories')
    cats = []
    if categories
      for category in categories
        cats.push "<a href='#categories/#{category.id}'>#{category.name}</a>"
      @$('#categories').append( cats.join(', ') )
        
  render: ->
    if @type == 'events'
      start = @convertTime @model.get('start_at')
      $(@el).html(@eventTemplate( result: @model, startAt: start ))
    else if @type == 'organizations'
      $(@el).html(@organizationTemplate( result: @model )).addClass 'organization'
      @renderCategories()
    else if @type == 'categories'
      $(@el).html(@categoryTemplate( result: @model ))
    return this