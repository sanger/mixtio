class Mixtio.Views.Consumables extends Backbone.View

  initialize: () ->
    @updateBatchVolume()
    @collection.on("change", () => @updateBatchVolume())

  update: () ->

    @updateBatchVolume()

  updateBatchVolume: () ->
    total_volume = @collection.reduce((memo, model) ->
       memo += model.get("quantity") * model.get("volume") * 10 ** Mixtio.Bootstrap.Units[model.get("unit")]
       memo
    , 0)

    # Set precison to remove some floating point errors
    precision = 12
    scaled_volume = Math.round(total_volume * 10 ** precision) / (10 ** precision)

    # Update the value in the text box
    @$el.val(scaled_volume)
