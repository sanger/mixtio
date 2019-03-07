$(document).on("turbolinks:load", () ->
  for item in $("[data-behavior='batch-form']")

    # Create the Collections
    userFavouritesCollection  = new Mixtio.Collections.UserFavourites(Mixtio.Bootstrap.UserFavourites)
    consumableTypesCollection = new Mixtio.Collections.ConsumableTypes(Mixtio.Bootstrap.ConsumableTypes)
    kitchensCollection        = new Mixtio.Collections.Kitchens(Mixtio.Bootstrap.Kitchens)
    ingredientsCollection     = new Mixtio.Collections.Ingredients(Mixtio.Bootstrap.Ingredients)
    projectsCollection        = new Mixtio.Collections.Projects(Mixtio.Bootstrap.Projects)
    unitsCollection           = new Mixtio.Collections.Units(Mixtio.Bootstrap.InputUnits)
    currentRecipe             = new Mixtio.Collections.Ingredients

    # Collection of sub-batch details (volume and unit, soon also projects)
    subBatchesCollection      = new Mixtio.Collections.SubBatches(Mixtio.Bootstrap.SubBatches)

    # Create the Views
    consumableTypeView = new Mixtio.Views.ConsumableTypes(
      el: $('#mixable_consumable_type_id')
      collection: consumableTypesCollection
      favourites: userFavouritesCollection
    )

    favouritesStarView = new Mixtio.Views.FavouritesStar(el: $('i.fa-star'))

    ingredientsView = new Mixtio.Views.Ingredients(
      el: $('#mixable-ingredients-table')
      collection: ingredientsCollection
      consumableTypes: consumableTypesCollection
      kitchens: kitchensCollection
      units: unitsCollection
      forRecipe: false
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

    expiryDateView = new Mixtio.Views.ExpiryDate(el: $('#mixable_expiry_date'))

    # Handles live calculation of batch volume
    consumablesView = new Mixtio.Views.Consumables(
      el: $('#calculated_batch_volume')
      collection: subBatchesCollection
    )

    confirmableBatchForm = new Mixtio.Views.ConfirmableBatchForm(
      el: $(item)
      currentIngredients: ingredientsCollection
      currentRecipe: currentRecipe
    )

    # Wire everything together

    ## When a favourite is added/removed to/from the User Favourites, update the Consumable Types view
    consumableTypeView.listenTo(userFavouritesCollection, 'add remove', consumableTypeView.render)

    ## When the Consumable Type is changed, update the Favourites Star, the Use by date, and set
    ## the Ingredients
    consumableTypeView.on("change:selected", (model, options) ->
      favouritesStarView.update(model, options)
      expiryDateView.update(model)
      consumablesView.update(model)

      prefill_data = model?.get('prefill_data')

      ingredients = prefill_data?.ingredients
      subBatchUnit = prefill_data?.sub_batch_unit

      currentRecipe.reset(ingredients)
      ingredientsCollection.reset(ingredients)

      subBatchesView.setUnit(subBatchUnit)
      addSubBatchView.defaultUnit = subBatchUnit
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
      currentRecipe.reset(selectedConsumableType.get('prefill_data').ingredients)
    ingredientsView.render()
    subBatchesView.render()

  $('[data-toggle="tooltip"]').tooltip()
)
