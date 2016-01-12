$ ->
  for item in $("[data-behavior~=batch-ingredients-table]")
    ingredients_table = new @IngredientsTable($(item))
    batch_form = new @BatchForm($("#new_batch_form"), ingredients_table)
    scan_input = new @ScanConsumableInput($("#consumable-barcode"), ingredients_table)
    ingredient_button = new @AddIngredientButton($("#add_ingredient_button"), ingredients_table, scan_input)

  $('[data-toggle="tooltip"]').tooltip()