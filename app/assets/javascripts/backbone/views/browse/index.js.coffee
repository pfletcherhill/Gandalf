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
    @count = 0
    @render(@results)
  
  # Render the contents of search results, numberOfResults at a time.
  # param {Collection.<Organization|Category|Event>} results The results
  #   fetched by the router.
  # param {number} numberOfResults The number to render.
  renderResults: (results, numberOfResults) ->
    numberOfResults ||= 12 # Default to 12
    for num in [1..numberOfResults]
      if @count < results.models.length
        @addResult results.models[@count]
        @count++
      else return false
    true
  
  addResult: (result) ->
    view = new Gandalf.Views.Browse.Show(model: result, type: @type)
    @$("#browse-list").append(view.render().el)
    
  render: ->
    @$el.html(@template(type: @type))
    @$("#browse-list").html('')
    @renderResults @results, 20 # Render first 20
    @changeActive(@type)
    setTimeout(=>               # Render rest a bit later so the user can see something
      while(@renderResults(@results))
        ; # Do nothing
    , 500)
    return this
  
  changeActive: (type) ->
    @$("a[data-type=#{type}]").addClass 'active'
  
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
