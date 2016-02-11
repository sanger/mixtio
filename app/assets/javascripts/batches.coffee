$ ->
  for item in $("[data-behavior~=batch-ingredients-table]")
    ingredients_table = new @IngredientsTable($(item))
    batch_form = new @BatchForm($("#new_batch_form"), ingredients_table)
    scan_input = new @ScanConsumableInput($("#consumable-barcode"), ingredients_table)
    ingredient_button = new @AddIngredientButton($("#add_ingredient_button"), ingredients_table, scan_input)

    userFavouritesCollection  = new Mixtio.Collections.UserFavourites(userFavourites)
    consumableTypesCollection = new Mixtio.Collections.ConsumableTypes(consumableTypes, favourites: userFavouritesCollection)

    consumable_type_view = new Mixtio.Views.ConsumableTypes(
      el: $('#batch_form_consumable_type_id')
      collection: consumableTypesCollection
    )

    consumable_type_view.listenTo(userFavouritesCollection, 'add remove', () ->
      consumable_type_view.render()
    )

    favourites_star = new Mixtio.Views.FavouritesStar(
      el: $('i.fa-star')
    )

    favourites_star.listenTo(consumable_type_view, 'change:selected', favourites_star.update)

    userFavouritesCollection.listenTo(favourites_star, 'favourite', (model) ->
      userFavouritesCollection.add(model)
    )

    userFavouritesCollection.listenTo(favourites_star, 'unfavourite', (model) ->
      userFavouritesCollection.remove(model)
    )

    consumable_type_view.render()



  $('[data-toggle="tooltip"]').tooltip()