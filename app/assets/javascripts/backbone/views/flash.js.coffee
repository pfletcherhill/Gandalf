Gandalf.Views ||= {}

class Gandalf.Views.Flash extends Backbone.View
  
  initialize: ->
    Gandalf.dispatcher.on("flash:success", @success, this)
    Gandalf.dispatcher.on("flash:error", @error, this)
    Gandalf.dispatcher.on("flash:notice", @notice, this)
    @displayLength = 5*1000 # 10 seconds
    @render()

  events:
    "click" : "hide"

  render: ->
    @$el.html("")
    return this

  id: "flash"
  template: JST["backbone/templates/flash/index"]

  success: (msg) ->
    @hide()
    @$el.html(msg).addClass "success"
    @flash()
    # console.log "flash success:",  msg

  error: (msg) ->
    @hide()
    @$el.html(msg).addClass "error"
    @flash()
    # console.log "flash error:",  msg

  notice: (msg) ->
    @hide()
    @$el.html(msg).addClass "notice"
    @flash()
    # console.log "flash notice:",  msg

  flash: ->
    @$el.fadeIn()

  hide: ->
    @$el.hide()
    @$el.removeClass("success error notice")
