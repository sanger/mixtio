class Mixtio.Views.ConsumableTypes extends Backbone.View

  events:
    change: 'setSelected'

  initialize: (options) ->
    @favourites_collection = options.favourites

  empty: () ->
    @$el.html('')

  render: () ->
    @empty()
    @renderEmpty()
    @renderOptions(@collection.filter(@isFavourite))
    @renderDisabled()
    @renderOptions(@collection.reject(@isFavourite))
    @$el.val(@selected.id) if @selected?
    this

  renderEmpty: (spacer = '') ->
    @$el.append(JST["empty_option"]())

  renderDisabled: () ->
    @$el.append(JST["disabled_option"]())

  renderOptions: (collection) ->
    collection.forEach((consumable_type) =>
      view = new Mixtio.Views.Option(model: consumable_type).render().el
      @$el.append(view)
    )

  setSelected: () ->
    id = @$el.val()

    if id is ""
      @selected = undefined
      isFavourite = false
    else
      @selected = @collection.findWhere({id: parseInt(id)})
      isFavourite = @isFavourite(@selected)

    @trigger('change:selected', @selected, isFavourite: isFavourite)

  isFavourite: (consumableType) =>
    @favourites_collection.where(id: consumableType.id).length is 1