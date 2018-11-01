class Mixtio.Views.Ingredient extends Backbone.View

  tagName: 'tr'

  events:
    'change select[name*="consumable_type_id"]': 'update'
    'change input[name*="number"]': 'setNumber'
    'change select[name*="kitchen_id"]': 'setKitchenId'
    'change input[name*="quantity"]': 'setQuantity'
    'change select[name*="unit_id"]': 'setUnitId'
    'click a[data-behavior~=remove_row]': 'close'

  initialize: (options) ->
    @consumableTypes = options.consumableTypes
    @kitchens        = options.kitchens
    @units           = options.units
    @forRecipe       = options.forRecipe

    @on("render", () => @setSubviews())

  setSubviews: () ->
    @consumableTypeSelect = @$el.find('select[name*="consumable_type_id"]')
    @numberInput          = @$el.find('input[name*="number"]')
    @kitchenSelect        = @$el.find('select[name*="kitchen_id"]')
    @quantityInput        = @$el.find('input[name*="quantity"]')
    @unitSelect           = @$el.find('select[name*="unit_id"]')

  render: () ->
    @$el.html(JST['batches/ingredient'](
      ingredient: @model
      consumableTypes: @consumableTypes
      kitchens: @kitchens
      units: @units
      forRecipe: @forRecipe
    ))

    @trigger("render")
    this

  update: () ->
    selectedId = @consumableTypeSelect.val()
    @setConsumableTypeId()
    consumableType = @consumableTypes.findWhere({ id: parseInt(selectedId) })

    lot = consumableType?.get('latest_lot')
    if lot?
      @model.set({ number: lot.number })
      @model.set({ kitchen_id: lot.kitchen_id })
    else
      @model.set({ number: "" })
      @model.set({ kitchen_id: "" })

    @render()
    this

  close: (e) ->
    e.preventDefault()
    @$el.remove()
    @collection.remove(@model)

  setConsumableTypeId: () ->
    @model.set({ consumable_type_id: @consumableTypeSelect.val() })

  setNumber: () ->
    @model.set({ number: @numberInput.val() })

  setKitchenId: () ->
    @model.set({ kitchen_id: @kitchenSelect.val() })

  # Setting to null if value is "" because that's what it is coming from "mixable criteria" on the server
  setQuantity: () ->
    @model.set({ quantity: @quantityInput.val() || null })

  setUnitId: () ->
    @model.set({ unit_id: @unitSelect.val() || null })