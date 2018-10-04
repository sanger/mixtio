class Mixtio.Views.AddSubBatch extends Backbone.View

  defaultUnit: null

  events:
    "click": "click"

  click: (e) ->
    # Stops the button form submitting the form
    e.preventDefault()
    # Adds an item to the current collection (subBatchesCollection)
    entry = { 'unit': this.defaultUnit }
    if @collection.length > 0
      last = @collection.models[@collection.length-1]
      if last.attributes.unit
        entry.unit = last.attributes.unit
    @collection.add(entry)
