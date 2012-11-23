Gandalf.Views.Organizations ||= {}

class Gandalf.Views.Organizations.Edit extends Backbone.View
  
  template: JST["backbone/templates/organizations/edit"]
  
  id: 'organization'
    
  initialize: ->
    @render(@model)
  
  renderUpload: =>
    url = '/organizations/' + @model.id + '/add_image'
    @$("#new-image").fileupload
      dataType: "json"
      autoUpload: true
      url: url
      done: (e, data) =>
        @model.set data.result
        @render(@model)
      fail: (e, data) ->
        alert 'Upload failed'
      start: (e, data) =>
        @$("#open-image").html('Uploading...')
        @$(".image").html('').addClass 'loading'
          
  render: ->
    $(@el).html(@template( @model.toJSON() ))
    @$("form#organization-form").backboneLink(@model)
    @renderUpload()
    return this
  
  events:
    "submit form#organization-form" : 'save'
    "click #open-image" : "openImage"
  
  save: (event) ->
    event.preventDefault()
    event.stopPropagation()
    @$("button").html('Updating...')
    @model.url = "/organizations/" + @model.id
    @model.save(@model,
      success: (organization) =>
        @$("button").html('Update Organization')
        @model.trigger('updated')
      error: (organization, jqXHR) =>
        @$("button").html('Update Organization')
        @model.set({errors: $.parseJSON(jqXHR.responseText)})
    )
  
  openImage: (event) ->
    $("#new-image").click()