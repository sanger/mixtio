class Mixtio.Views.ConsumableTypes extends Backbone.View

  events:
    change: 'setSelected'

  empty: () ->
    @$el.html('')

  render: () ->
    @empty()
    @renderSpacer()
    @renderOptions(@collection.favourites())
    @renderDisabled()
    @renderOptions(@collection.nonFavourites())
    @$el.val(@selected.id) if @selected?
    this

  renderSpacer: (spacer = '') ->
    @$el.append($("<option value=''>#{spacer}</option>"))

  renderDisabled: () ->
    @$el.append($("<option>#{new Array(20).join('&#9472')}</option>").attr("disabled", "disabled"))

  renderOptions: (collection) ->
    collection.forEach((consumable_type) =>
      view = new Mixtio.Views.ConsumableTypeOption(model: consumable_type).render().el
      @$el.append(view)
    )

  setSelected: () ->
    id = @$el.val()

    if id is ""
      @selected = undefined
      isFavourite = false
    else
      @selected = @collection.findWhere({id: parseInt(id)})
      isFavourite = @collection.isFavourite(@selected)

    @trigger('change:selected', @selected, isFavourite: isFavourite)