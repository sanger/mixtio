class Mixtio.Views.AddSubBatch extends Backbone.View

  events:
    "click": "click"

  click: (e) ->
    # Stops the button form submitting the form
    e.preventDefault()
    # Adds an empty item to the current collection (subBatchesCollection)
    @collection.add({})
