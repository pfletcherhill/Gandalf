Gandalf.Views.Organizations ||= {}

class Gandalf.Views.Organizations.Edit extends Backbone.View
  
  template: JST["backbone/templates/organizations/edit"]
  
  id: 'organization'
    
  initialize: ->
    @render(@model)
  
  render: ->
    $(@el).html(@template( @model.toJSON() ))
    @$("form#organization-form").backboneLink(@model)
    return this
  
  events:
    "submit form#organization-form" : 'save'
  
  save: (event) ->
    event.preventDefault()
    event.stopPropagation()
    @model.save(@model,
      success: (organization) =>
        @model.trigger('updated')
      error: (organization, jqXHR) =>
        @model.set({errors: $.parseJSON(jqXHR.responseText)})
    )