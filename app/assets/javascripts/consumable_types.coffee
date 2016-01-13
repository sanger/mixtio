$ ->
  for item in $("[data-behavior~=ct-ingredients-table]")
    ingredients_table = new @IngredientsTable($(item))
    ingredient_button = new @AddIngredientButton($("#add_ingredient_button"), ingredients_table)

