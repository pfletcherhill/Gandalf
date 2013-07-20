# Backbone's representation of the team model.

class Gandalf.Models.Team extends Backbone.Model
  
  paramRoot: 'team'

  defaults:
    name: null

class Gandalf.Collections.Teams extends Backbone.Collection
  model: Gandalf.Models.Team
  url: '/teams'