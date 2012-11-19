class Gandalf.Models.Event extends Backbone.Model
  paramRoot: 'event'

  defaults:
    name: null

class Gandalf.Collections.EventsCollection extends Backbone.Collection
  model: Gandalf.Models.Event
  url: '/events'
