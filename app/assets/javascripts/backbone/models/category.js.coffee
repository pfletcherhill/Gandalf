class Gandalf.Models.Category extends Backbone.Model
  paramRoot: 'category'

  defaults:
    name: null

class Gandalf.Collections.Categories extends Backbone.Collection
  model: Gandalf.Models.Category
  url: '/categories'
