Gandalf.Views.Browse ||= {}

class Gandalf.Views.Browse.Index extends Backbone.View
  
  template: JST["backbone/templates/browse/index"]
  
  id: "browse"

  events:
    'keyup input' : 'search'
    # 'scroll #browse-list' : 'scroll'
  
  initialize: =>
    @results = @options.results
    @searchResults = new Backbone.Collection
    @type = @options.type
    @count = 0
    @render(@results)
  
  renderResults: (results) ->
    for num in [1..12]    # 12 times
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
    @renderResults @results     # Render first 20
    @changeActive(@type)
    setTimeout(=>               # Render rest a bit later so the user can see something
      while(@renderResults(@results))
        ; # Do nothing
    , 500)
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
