Gandalf.Views.Preferences ||= {}

class Gandalf.Views.Preferences.Index extends Backbone.View
  template: JST["backbone/templates/preferences/index"]
  subscriptionTemplate: JST["backbone/templates/preferences/subscription"]
  
  initialize: ->
    @type = @options.type
    @subscriptions = @options.subscriptions
    @render()
    
  render: =>
    $(@el).html(@template())
    @renderSubscriptions()
    @changeActive(@type)
    return this
  
  changeActive: (type) ->
    @$("li[data-type=#{type}]").addClass 'selected'
      
  renderSubscriptions: =>
    for subscription in @subscriptions.models
      if subscription.get('subscribeable_type') == 'Category'
        url = "#categories/" + subscription.get('subscribeable_id')
      else
        url = "#organizations/" + subscription.get('subscribeable_id')
      @$("tbody").append(@subscriptionTemplate(url: url, sub: subscription.toJSON()))