class Gandalf.Models.Organization extends Backbone.Model
  paramRoot: 'organization'

  defaults:
    name: null
    
    asJSON: =>
      organization = _.clone this.attributes
      return _.extend organization, {image: this.get('image')}
    
class Gandalf.Collections.Organizations extends Backbone.Collection
  model: Gandalf.Models.Organization
  url: '/organizations'
