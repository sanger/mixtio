$(document).on("turbolinks:load", () ->
  for item in $("[data-behavior='consumable-type-form']")

    # Create the Collections
    consumableTypesCollection = new Mixtio.Collections.ConsumableTypes(Mixtio.Bootstrap.ConsumableTypes)
    kitchensCollection        = new Mixtio.Collections.Kitchens(Mixtio.Bootstrap.Kitchens)
    ingredientsCollection     = new Mixtio.Collections.Ingredients(Mixtio.Bootstrap.Ingredients)
    unitsCollection           = new Mixtio.Collections.Units(Mixtio.Bootstrap.InputUnits)

    ingredientsView = new Mixtio.Views.Ingredients(
      el: $('#mixable-ingredients-table')
      collection: ingredientsCollection
      consumableTypes: consumableTypesCollection
      kitchens: kitchensCollection
      units: unitsCollection
      forRecipe: true
    )

    addIngredientView = new Mixtio.Views.AddIngredient(
      el: $('#add_ingredient_button')
      collection: ingredientsCollection
    )

    # And finally render
    ingredientsView.render()
)
