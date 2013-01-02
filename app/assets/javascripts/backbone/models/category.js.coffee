class Gandalf.Models.Category extends Backbone.Model
  paramRoot: 'category'

  defaults:
    name: null
  
  fetchEvents: (string) ->
    if string
      string = '?' + string
    else
      string = ''
    $.ajax
      type: 'GET'
      dataType: 'json'
      url: '/categories/' + @id + '/events' + string
      success: (data) =>
        console.log data
        @set events: data

class Gandalf.Collections.Categories extends Backbone.Collection
  model: Gandalf.Models.Category
  url: '/categories'
