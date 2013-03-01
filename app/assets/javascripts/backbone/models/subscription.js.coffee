class Gandalf.Models.Subscription extends Backbone.Model
  paramRoot: 'subscription'

  defaults:
    subscribeable_type: null
  
class Gandalf.Collections.Subscriptions extends Backbone.Collection
  model: Gandalf.Models.Subscription