class Mixtio.Models.ConsumableType extends Backbone.Model

  favourite: () ->
    @_favourites_controller('create')

  unfavourite: () ->
    @_favourites_controller('delete')

  _favourites_controller: (method) =>
    url = '/favourites/' + @id
    Backbone.sync(method, @, url: url)
