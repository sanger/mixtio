$ ->
  for item in $("#batch-ingredients-table")

    # Create the Collections
    userFavouritesCollection  = new Mixtio.Collections.UserFavourites(Mixtio.Bootstrap.UserFavourites)
    consumableTypesCollection = new Mixtio.Collections.ConsumableTypes(Mixtio.Bootstrap.ConsumableTypes)
    kitchensCollection        = new Mixtio.Collections.Kitchens(Mixtio.Bootstrap.Kitchens)
    ingredientsCollection     = new Mixtio.Collections.Ingredients()

    # Create the Views
    consumableTypeView = new Mixtio.Views.ConsumableTypes(
      el: $('#batch_form_consumable_type_id')
      collection: consumableTypesCollection
      favourites: userFavouritesCollection
    )

    favouritesStarView = new Mixtio.Views.FavouritesStar(el: $('i.fa-star'))

    ingredientsView = new Mixtio.Views.Ingredients(
      el: item,
      collection: ingredientsCollection
      consumableTypes: consumableTypesCollection
      kitchens: kitchensCollection
    )

    scanConsumableView = new Mixtio.Views.ScanConsumable(
      el: $('#consumable-barcode')
      collection: ingredientsCollection
    )

    addIngredientView = new Mixtio.Views.AddIngredient(
      el: $('#add_ingredient_button')
      collection: ingredientsCollection
    )

    expiryDateView = new Mixtio.Views.ExpiryDate(el: $('#batch_form_expiry_date'))

    # Wire everything together

    ## When a favourite is added/removed to/from the User Favourites, update the Consumable Types view
    consumableTypeView.listenTo(userFavouritesCollection, 'add remove', consumableTypeView.render)

    ## When the Consumable Type is changed, update the Favourites Star, the Expiry Date, and set
    ## the Ingredients
    consumableTypeView.on("change:selected", (model, options) ->
      favouritesStarView.update(model, options)
      expiryDateView.update(model)

      if model.get('recipe_ingredients').length is 0
        ingredientsCollection.reset()
      else
        ingredientsCollection.findAndSetToLatest(model.get('recipe_ingredients'))
    )

    ## When the user favourites/unfavourites a Consumable Type, add/remove it to/from the collection
    userFavouritesCollection.listenTo(favouritesStarView, 'favourite', userFavouritesCollection.add)
    userFavouritesCollection.listenTo(favouritesStarView, 'unfavourite', userFavouritesCollection.remove)

    # And finally render
    consumableTypeView.render()

  $('[data-toggle="tooltip"]').tooltip()