#= require sinon
#= require ../../../app/assets/javascripts/application

describe "Router", ->
  beforeEach ->
    @currentUser = sinon.mock(Gandalf.Models.User)
    @router = new window.Gandalf.Router(@currentUser)
    @routeSpy = sinon.spy()
    try
      Backbone.history.start {silent:true, pushState:true}
    @router.navigate "/"

  it "fires the index route with a blank hash", ->
    @router.bind "route:index", this.routeSpy
    @router.navigate "", true
    # expect(@routeSpy).toHaveBeenCalled()
    expect(@routeSpy).toHaveBeenCalledWith('a')
