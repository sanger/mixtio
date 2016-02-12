class Mixtio.Views.RecipeIngredient extends Backbone.View

  tagName: 'tr'

  events:
    'change select[name*="recipe_ingredient_id"]': 'update'
    'click a[data-behavior~=remove_row]': 'close'

  initialize: (options) ->
    @consumableTypes = options.consumableTypes
    @on("render", () => @setSubviews())

  setSubviews: () ->
    @recipeIngredientSelect = @$el.find('select[name*="recipe_ingredient_id"]')

  render: () ->
    @$el.html(JST['consumable_types/recipe_ingredient'](
      recipeIngredient: @model
      consumableTypes: @consumableTypes
    ))

    @trigger('render')

    this

  update: () ->
    @model.set({id: parseInt(@recipeIngredientSelect.val())})

  close: (e) ->
    e.preventDefault()
    @$el.fadeOut(400, () =>
      @el.remove()
      @collection.remove(@model)
    )