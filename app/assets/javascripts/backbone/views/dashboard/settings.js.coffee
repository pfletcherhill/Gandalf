Gandalf.Views.Dashboard ||= {}

class Gandalf.Views.Dashboard.Settings extends Backbone.View
  
  template: JST["backbone/templates/dashboard/settings/index"]
  eventTemplate: JST["backbone/templates/dashboard/events/show"]
  
  className: 'dash-org-container'
    
  initialize: =>
    @render()
    # @model.fetchEvents().then @renderEvents
  
  renderUpload: =>
    url = "/organizations/#{@model.get("id")}/add_image"
    console.log url
    @$("#organization-image").fileupload
      dataType: "json"
      autoUpload: true
      url: url
      start: (e, data) =>
        @$(".image").html('').addClass 'loading'
      done: (e, data) =>
        @model.set data.result
        @render()
      fail: (e, data) ->
        alert 'Upload failed, please try again later.'
       
  render: ->
    @$el.html @template(@model.toJSON())
    # @modelBinder.bind(@model, @$("#organization-form"))
    $("li[data-id='#{@model.id}']").addClass 'selected'
    @$(".image").removeClass 'loading'
    # @$("form#organization-form").backboneLink(@model)
    @renderUpload()
    return this
  
  events:
    "submit #dash-settings-form" : 'save'
    'click #open-image' : 'openImage'
  
  save: (event) ->
    submit = @$("input[type='submit']")
    $(submit).val('Updating...')
    @model.unset 'events'
    @model.set
      name: $("input[name='name']").val()
      bio: $("textarea[name='bio']").val()
    @model.url = "/organizations/" + @model.id
    @model.save(@model,
      success: (organization) =>
        $(submit).val('Update Organization')
        @model.trigger('updated')
      error: (organization, jqXHR) =>
        $(submit).val('Update Organization')
        @model.set({errors: $.parseJSON(jqXHR.responseText)})
    )
    # Instead of stopPropogation and preventDefault, just return false!
    return false

  openImage: ->
    @$("#organization-image").click()