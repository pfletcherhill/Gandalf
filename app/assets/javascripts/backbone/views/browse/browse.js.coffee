Gandalf.Views.Events ||= {}

class Gandalf.Views.Events.Browse extends Backbone.View
  
  template: JST["backbone/templates/events/browse/browse"]
  
  id: "browse"
  
  initialize: =>
    @results = @options.results
    @searchResults = new Backbone.Collection
    @type = @options.type
    @render(@results)
  
  renderResults: (results) ->
    @$("#browse-list").html('')
    _.each results.models, (result) =>
      @addResult result
  
  addResult: (result) ->
    view = new Gandalf.Views.Events.BrowseResult(model: result, type: @type)
    @$("#browse-list").append(view.render().el)
    
  render: ->
    $(@el).html(@template(type: @type))
    @renderResults @results
    @changeActive(@type)
    return this
  
  changeActive: (type) ->
    @$("a[data-type=#{type}]").addClass 'active'
  
  stringToUrl: (string) ->
    string = string.replace(' ','%20')
    string = string.replace('.','%2E')
    string
    
  events:
    'keyup input' : 'search'
  
  search: (event) ->
    query = $(event.target).val()
    if query.length > 0
      query = @stringToUrl query
      @searchResults.url = '/search/' + @type + '/' + query
      @searchResults.fetch success: (results) =>
        results
        @renderResults results
    else
      @renderResults @results