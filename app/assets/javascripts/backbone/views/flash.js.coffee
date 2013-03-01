Gandalf.Views ||= {}

class Gandalf.Views.Flash extends Backbone.View
  
  initialize: ->
    Gandalf.dispatcher.on("flash:success", @success, this)
    Gandalf.dispatcher.on("flash:error", @error, this)
    Gandalf.dispatcher.on("flash:notice", @notice, this)

  success: (msg) ->
    console.log "flash success:",  msg

  error: (msg) ->
    console.log "flash error:",  msg

  notice: (msg) ->
    console.log "flash notice:",  msg