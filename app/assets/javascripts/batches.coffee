$(document).on("turbolinks:load", () ->
  for item in $("#batch-ingredients-table")

    # Create the Collections
    userFavouritesCollection  = new Mixtio.Collections.UserFavourites(Mixtio.Bootstrap.UserFavourites)
    consumableTypesCollection = new Mixtio.Collections.ConsumableTypes(Mixtio.Bootstrap.ConsumableTypes)
    kitchensCollection        = new Mixtio.Collections.Kitchens(Mixtio.Bootstrap.Kitchens)
    ingredientsCollection     = new Mixtio.Collections.Ingredients(Mixtio.Bootstrap.Ingredients)
    projectsCollection        = new Mixtio.Collections.Projects(Mixtio.Bootstrap.Projects)
    unitsCollection           = new Mixtio.Collections.Units(Mixtio.Bootstrap.InputUnits)

    # Collection of sub-batch details (volume and unit, soon also projects)
    subBatchesCollection      = new Mixtio.Collections.SubBatches(Mixtio.Bootstrap.SubBatches)

    # Create the Views
    consumableTypeView = new Mixtio.Views.ConsumableTypes(
      el: $('#batch_form_consumable_type_id')
      collection: consumableTypesCollection
      favourites: userFavouritesCollection
    )

    favouritesStarView = new Mixtio.Views.FavouritesStar(el: $('i.fa-star'))

    ingredientsView = new Mixtio.Views.Ingredients(
      el: item
      collection: ingredientsCollection
      consumableTypes: consumableTypesCollection
      kitchens: kitchensCollection
      units: unitsCollection
    )

    scanConsumableView = new Mixtio.Views.ScanConsumable(
      el: $('#consumable-barcode')
      collection: ingredientsCollection
    )

    addIngredientView = new Mixtio.Views.AddIngredient(
      el: $('#add_ingredient_button')
      collection: ingredientsCollection
    )

    subBatchesView = new Mixtio.Views.SubBatches(
      el: $("#batch-sub-batch-table")
      collection: subBatchesCollection
    )

    addSubBatchView = new Mixtio.Views.AddSubBatch(
      el: $('#add_sub_batch_button')
      collection: subBatchesCollection
    )

    expiryDateView = new Mixtio.Views.ExpiryDate(el: $('#batch_form_expiry_date'))

    # Handles live calculation of batch volume
    consumablesView = new Mixtio.Views.Consumables(
      el: $('#calculated_batch_volume')
      collection: subBatchesCollection
    )

    # Wire everything together

    ## When a favourite is added/removed to/from the User Favourites, update the Consumable Types view
    consumableTypeView.listenTo(userFavouritesCollection, 'add remove', consumableTypeView.render)

    ## When the Consumable Type is changed, update the Favourites Star, the Expiry Date, and set
    ## the Ingredients
    consumableTypeView.on("change:selected", (model, options) ->
      favouritesStarView.update(model, options)
      expiryDateView.update(model)
      consumablesView.update(model)

      ingredients = model?.get('ingredients_prefill')

      ingredientsView.update(new Mixtio.Collections.Ingredients(ingredients))
    )

    ## When the user favourites/unfavourites a Consumable Type, add/remove it to/from the collection
    userFavouritesCollection.listenTo(favouritesStarView, 'favourite', userFavouritesCollection.add)
    userFavouritesCollection.listenTo(favouritesStarView, 'unfavourite', userFavouritesCollection.remove)

    # And finally render
    consumableTypeView.render()
    consumableTypeView.setSelected(Mixtio.Bootstrap.SelectedConsumableType)
    selectedConsumableType = consumableTypesCollection.findWhere({id: parseInt(Mixtio.Bootstrap.SelectedConsumableType)})
    if selectedConsumableType?
      favouritesStarView.update(selectedConsumableType, {isFavourite: !!userFavouritesCollection.findWhere({id: selectedConsumableType.id})})
    ingredientsView.render()
    subBatchesView.render()

  $('[data-toggle="tooltip"]').tooltip()
)
