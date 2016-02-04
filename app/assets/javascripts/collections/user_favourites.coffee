class Mixtio.Collections.UserFavourites extends Backbone.Collection

  model: Mixtio.Models.ConsumableType

  initialize: () ->
    @on('add', (model) => model.favourite() )
    @on('remove', (model) => model.unfavourite() )