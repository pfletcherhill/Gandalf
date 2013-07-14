Gandalf.Views.Browse ||= {}

class Gandalf.Views.Browse.Index extends Backbone.View
  
  template: JST["backbone/templates/browse/index"]
  allTemplate: JST["backbone/templates/browse/all"]
  
  id: "browse"
  
  initialize: ->
    @$el.html(@template(type: @options.type))
    @render(@options.results, @options.type)
  
  renderResults: (results, identifier = '#browse-list', type = @options.type) ->
    for result in results.models
      view = new Gandalf.Views.Browse.Show(model: result, type: type)
      @$(identifier).append(view.render().el)
    
  render: (results, type) ->
    @$("#browse-list").html('')
    if type == 'all'
      @$("#browse-list").html @allTemplate()
      for browseType in ["events", "organizations", "categories"]
        @renderResults(
          new Backbone.Collection(results.get(browseType)),
          "#browse-#{browseType}",
          browseType
        )
    else
      collection = new Backbone.Collection(results.get(type))
      @renderResults(collection)
    @changeActive(type)
    return this
  
  changeActive: (type) ->
    @$("a[data-type=#{type}]").addClass 'active'
  
  stringToUrl: (string) ->
    string = string.replace(' ','%20')
    string = string.replace('.','%2E')
    string
  
  events:
    'keyup #search-form input' : 'search'
  
  search: (event) ->
    event.preventDefault()
    query = $(event.target).val()
    if query.length > 0
      query = @stringToUrl query
      @searchResults = new Backbone.Model
      @searchResults.url = '/search?type=' + @options.type + '&query=' + query
      @searchResults.fetch success: (results) =>
        @render results, @options.type
    else
      @render @options.results, @options.type
