class Mixtio.Models.ConsumableType extends Backbone.Model

  initialize: (attributes) ->
    attributes.recipe_ingredients ||= []
    @set('recipe_ingredients', new Mixtio.Collections.ConsumableTypes(attributes.recipe_ingredients))

  favourite: () ->
    @_favourites_controller('create')

  unfavourite: () ->
    @_favourites_controller('delete')

  _favourites_controller: (method) =>
    url = '/favourites/' + @id
    Backbone.sync(method, @, url: url)
