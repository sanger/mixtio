class Mixtio.Views.ExpiryDate extends Backbone.View

  update: (model) ->
    @model = model
    @render()

  render: () ->
    @$el.datepicker('setDate', @model?.get('days_to_keep'))
    this