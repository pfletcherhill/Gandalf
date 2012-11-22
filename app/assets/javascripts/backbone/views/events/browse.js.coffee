Gandalf.Views.Events ||= {}

class Gandalf.Views.Events.Browse extends Backbone.View
  
  template: JST["backbone/templates/events/browse"]
  
  id: "browse"
  
  initialize: =>
    @results = @options.results
    @type = @options.type
    @render(@results)
  
  renderResults: (results) ->
    _.each results.models, (result) =>
      @addResult result
  
  addResult: (result) ->
    view = new Gandalf.Views.Events.BrowseResult(model: result)
    @$("#browse-list").append(view.render().el)
    
  render: ->
    $(@el).html(@template(type: @type))
    @renderResults @results
    @changeActive(@type)
    return this
  
  changeActive: (type) ->
    @$("a[data-type=#{type}]").addClass 'active'