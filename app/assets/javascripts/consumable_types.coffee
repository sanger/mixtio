$ ->
  for item in $("form[data-behavior~=consumable_type_form]")
    # Create Collections
    consumableTypesCollection   = new Mixtio.Collections.ConsumableTypes(Mixtio.Bootstrap.ConsumableTypes)
    recipeIngredientsCollection = new Mixtio.Collections.ConsumableTypes(Mixtio.Bootstrap.RecipeIngredients)

    # Create Views
    recipeIngredientsView = new Mixtio.Views.RecipeIngredients(
      el: $('table', item)
      collection: recipeIngredientsCollection
      consumableTypes: consumableTypesCollection
    )

    addIngredientView = new Mixtio.Views.AddIngredient(
      el: $('#add_ingredient_button')
      collection: recipeIngredientsCollection
    )

    # And Render
    recipeIngredientsView.render()

