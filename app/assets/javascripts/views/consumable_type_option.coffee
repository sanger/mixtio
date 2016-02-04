class Mixtio.Views.ConsumableTypeOption extends Backbone.View

  tagName: 'option'

  render: () ->
    @$el.val(@model.get "id")
    @$el.html(@model.get "name")
    this