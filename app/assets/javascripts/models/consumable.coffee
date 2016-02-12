class Mixtio.Models.Consumable extends Backbone.Model

  batch: () ->
    new Mixtio.Models.Batch(id: @get('batch').id)