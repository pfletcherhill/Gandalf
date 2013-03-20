Gandalf.Views ||= {}

class Gandalf.Views.Flash extends Backbone.View
  
  initialize: ->
    Gandalf.dispatcher.on("flash:success", @success, this)
    Gandalf.dispatcher.on("flash:error", @error, this)
    Gandalf.dispatcher.on("flash:notice", @notice, this)
    @displayLength = 5*1000 # 10 seconds
    @render()

  events:
    "click #flash" : "hide"

  render: ->
    @$el.html("")
    return this

  id: "flash"
  template: JST["backbone/templates/flash/index"]

  success: (msg) ->
    @$el.html(msg).addClass "success"
    @flash()
    console.log "flash success:",  msg

  error: (msg) ->
    @$el.html(msg).addClass "error"
    @flash()
    console.log "flash error:",  msg

  notice: (msg) ->
    @$el.html(msg).addClass "notice"
    @flash()
    console.log "flash notice:",  msg

  flash: ->
    @$el.fadeIn().delay(@displayLength).fadeOut("normal", =>
      @$el.removeClass("success error notice")
    )

  hide: ->
    @$el.fadeOut("normal", =>
      @$el.removeClass("success error notice")
    )