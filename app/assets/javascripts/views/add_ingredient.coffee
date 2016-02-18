class Mixtio.Views.AddIngredient extends Backbone.View

  events:
    "click": "click"

  click: (e) ->
    e.preventDefault()
    @collection.add({})