class Mixtio.Views.Ingredients extends Backbone.View

  initialize: (options) ->
    @consumableTypes = options.consumableTypes
    @kitchens        = options.kitchens

    @collection.on('reset update', () => @render())

  render: () ->
    # Remove all the rows except the header
    @$el.find("tr:gt(0)").remove()

    @collection.each (ingredient) =>
      ingredientView = new Mixtio.Views.Ingredient(
        collection: @collection
        model: ingredient
        consumableTypes: @consumableTypes
        kitchens: @kitchens
      )

      @$el.append(ingredientView.render().el)

    this