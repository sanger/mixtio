class Mixtio.Views.FavouritesStar extends Backbone.View

  events:
    click: 'onClick'

  initialize: () ->
    @on('change:model', () => @change())

  update: (model, options) ->
    @model = model
    @isFavourite = options.isFavourite
    @trigger('change:model')

  onClick: () ->
    return if @model? is false
    @isFavourite = !@isFavourite
    if @isFavourite is true then @trigger('favourite', @model) else @trigger('unfavourite', @model)
    @change()

  change: () ->
    if @model? is false
      @disable()
    else if @isFavourite is true
      @activate()
    else
      @deactivate()

  activate: () ->
    @_setClass('favourite')

  deactivate: () ->
    @_setClass('unfavourite')

  disable: () ->
    @_setClass('disabled')

  _setClass: (klass) ->
    ['favourite', 'unfavourite', 'disabled'].forEach((klass) => @$el.removeClass(klass))
    @$el.addClass(klass)