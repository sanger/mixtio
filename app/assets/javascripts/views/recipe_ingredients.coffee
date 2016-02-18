class Mixtio.Views.RecipeIngredients extends Backbone.View

  initialize: (options) ->
    @consumableTypes = options.consumableTypes
    @collection.on('reset update', () => @render())

  render: () ->
    # Remove all the rows except the header
    @$el.find("tr:gt(0)").remove()

    @collection.each (ingredient) =>
      recipeIngredientView = new Mixtio.Views.RecipeIngredient(
        collection: @collection
        model: ingredient
        consumableTypes: @consumableTypes
      )

      @$el.append(recipeIngredientView.render().el)

    this