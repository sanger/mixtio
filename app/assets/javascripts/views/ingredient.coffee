class Mixtio.Views.Ingredient extends Backbone.View

  tagName: 'tr'

  events:
    'change select[name*="consumable_type_id"]': 'update'
    'click a[data-behavior~=remove_row]': 'close'

  initialize: (options) ->
    @consumableTypes = options.consumableTypes
    @kitchens        = options.kitchens

    @on("render", () => @setSubviews())

  setSubviews: () ->
    @consumableTypeSelect = @$el.find('select[name*="consumable_type_id"]')
    @numberInput          = @$el.find('input[name*="number"]')
    @kitchenSelect        = @$el.find('select[name*="kitchen_id"]')

  render: () ->
    @$el.html(JST['batches/ingredient'](
      ingredient: @model
      consumableTypes: @consumableTypes
      kitchens: @kitchens
    ))

    @trigger("render")
    this

  clear: () ->
    value = @consumableTypeSelect.val()
    @model.clear()
    @render()
    @consumableTypeSelect.val(value)

  update: () ->
    selectedId = @consumableTypeSelect.val()
    consumableType = @consumableTypes.filter((type) -> type.id == parseInt(selectedId))[0]

    lot = consumableType?.get('latest_lot')
    if lot?
      @numberInput.val(lot.number)
      @kitchenSelect.val(lot.kitchen_id)
    else
      @numberInput.val("")
      @kitchenSelect.val(null)

    this


  close: (e) ->
    e.preventDefault()
    @$el.remove()
    @collection.remove(@model)
