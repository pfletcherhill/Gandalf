Gandalf.Views.Browse ||= {}

class Gandalf.Views.Browse.Index extends Backbone.View
  
  template: JST["backbone/templates/browse/index"]
  
  id: "browse"

  events:
    'keyup input' : 'search'
  
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
    view = new Gandalf.Views.Browse.Show(model: result, type: @type)
    @$("#browse-list").append(view.render().el)
    
  render: ->
    @$el.html(@template(type: @type))
    @renderResults @results
    @changeActive(@type)
    return this
  
  changeActive: (type) ->
    @$("li[data-type=#{type}]").addClass 'selected'
  
  stringToUrl: (string) ->
    string = string.replace(' ','%20')
    string = string.replace('.','%2E')
    string
  
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