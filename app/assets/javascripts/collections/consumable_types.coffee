class Mixtio.Collections.ConsumableTypes extends Backbone.Collection

  initialize: (models, options) ->
    @favourites_collection = options.favourites

  model: Mixtio.Models.ConsumableType

  favourites: () ->
    @filter(@isFavourite)

  nonFavourites: () ->
    @reject(@isFavourite)

  isFavourite: (consumableType) =>
    @favourites_collection.where(id: consumableType.id).length is 1