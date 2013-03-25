Gandalf.Views.Events ||= {}

class Gandalf.Views.Browse.Show extends Backbone.View
  
  organizationTemplate: JST["backbone/templates/browse/organization"]
  eventTemplate: JST["backbone/templates/browse/event"]
  categoryTemplate: JST["backbone/templates/browse/category"]
  
  className: "browse-result"
  
  initialize: ->
    @type = @options.type
  
  convertTime: (time) ->
    moment(time).format("MMMM DD, h:mm a")

  renderCategories: ->
    categories = @model.get('categories')
    cats = []
    if categories and categories.length
      for category in categories
        cats.push "<a href='#categories/#{category.id}'>#{category.name}</a>"
      @$('.categories').append( cats.join(', ') )
    else
      @$('.categories').append("No associated categories")
        
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