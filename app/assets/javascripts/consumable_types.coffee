$ ->
  return unless $(".consumable_types.new").length > 0
  ingredients_table = new @IngredientsTable($("#ingredients_table"))
  ingredient_button = new @AddIngredientButton($("#add_ingredient_button"), ingredients_table)

