class Mixtio.Collections.Consumables extends Backbone.Collection

  url: "#{Mixtio.BaseURL}/consumables"

  model: Mixtio.Models.Consumable

  parse: (response, options) ->
    response.data[0]
