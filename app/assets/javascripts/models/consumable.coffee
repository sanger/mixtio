class Mixtio.Models.Consumable extends Backbone.Model

  batch: () ->
    new Mixtio.Models.Batch(id: @get('relationships').batch.data.id)