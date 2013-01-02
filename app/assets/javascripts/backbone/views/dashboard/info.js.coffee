Gandalf.Views.Dashboard ||= {}

class Gandalf.Views.Dashboard.Info extends Backbone.View
  
  template: JST["backbone/templates/dashboard/info/index"]
  eventTemplate: JST["backbone/templates/dashboard/events/show"]
  
  id: 'organization'
    
  initialize: =>
    @render()
    @model.fetchEvents().then @renderEvents
  
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
    $("li a[data-id='#{@model.id}']").parent().addClass 'selected'
    @$("form#organization-form").backboneLink(@model)
    @renderUpload()
    return this
  
  events:
    "submit form#organization-form" : 'save'
    "click button#new-event" : "openModal"
    "click .close" : "closeModal"
    "click #open-image" : "openImage"
  
  save: (event) ->
    event.preventDefault()
    event.stopPropagation()
    @$("button").html('Updating...')
    @model.unset 'events'
    @model.url = "/organizations/" + @model.id
    @model.save(@model,
      success: (organization) =>
        @$("button").html('Update Organization')
        @model.trigger('updated')
      error: (organization, jqXHR) =>
        @$("button").html('Update Organization')
        @model.set({errors: $.parseJSON(jqXHR.responseText)})
    )
  
  openModal: (event) ->
    @$(".modal").removeClass 'hide'
  
  closeModal: (event) ->
    @$(".modal").addClass 'hide'
    
  openImage: (event) ->
    $("#new-image").click()