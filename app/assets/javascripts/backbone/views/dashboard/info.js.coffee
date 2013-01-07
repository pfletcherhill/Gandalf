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
      start: (e, data) =>
        @$(".image").html('').addClass 'loading'
      done: (e, data) =>
        @model.set data.result
        @render()
      fail: (e, data) ->
        alert 'Upload failed'
       
  render: ->
    @$el.html(@template(@model.toJSON()))
    # @modelBinder.bind(@model, @$("#organization-form"))
    $("li a[data-id='#{@model.id}']").parent().addClass 'selected'
    # @$("form#organization-form").backboneLink(@model)
    @renderUpload()
    return this
  
  events:
    "submit #organization-form" : 'save'
    "click button#new-event" : "openModal"
    "click .close" : "closeModal"
  
  save: (event) ->
    event.preventDefault()
    event.stopPropagation()
    submit = @$("input[type='submit']")
    console.log submit
    $(submit).val('Updating...')
    @model.unset 'events'
    @model.url = "/organizations/" + @model.id
    @model.save(@model,
      success: (organization) =>
        console.log organization
        $(submit).val('Update Organization')
        @model.trigger('updated')
      error: (organization, jqXHR) =>
        $(submit).val('Update Organization')
        @model.set({errors: $.parseJSON(jqXHR.responseText)})
    )
  
  openModal: (event) ->
    @$(".modal").removeClass 'hide'
  
  closeModal: (event) ->
    @$(".modal").addClass 'hide'
