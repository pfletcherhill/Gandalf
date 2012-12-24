Gandalf.Views.Organizations ||= {}

class Gandalf.Views.Organizations.Show extends Backbone.View
  
  template: JST["backbone/templates/organizations/show/show"]
  calendarBody: JST["backbone/templates/organizations/show/org_calendar_week"]
  calendarDay: JST["backbone/templates/organizations/show/org_calendar_week_day"]
  
  el: '#content'
  
  initialize: ->
    @render()
  
  renderCalendar: ->
    @$(".content-calendar").html(@calendarBody())
    for i in [1..7]
      @$("tr.cal-day-container").append(@calendarDay())
  
  renderCategories: ->
    categories = @model.get('categories')
    cats = []
    if categories
      for category in categories
        cats.push "<a href='#categories/#{category.id}'>#{category.name}</a>"
      @$('.organization-categories').append( cats.join(', ') )
          
  render: ->
    $(@el).html(@template( organization: @model ))
    @renderCategories()
    @renderCalendar()
    return this
    