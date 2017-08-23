class Mixtio.Views.SubBatch extends Backbone.View

  tagName: 'tr'

  events:
    # Run the close function if the X button is clicked for the row
    'click a[data-behavior~=remove_row]': 'close'

  initialize: () ->
    @on("render", () => @setSubviews())

  setSubviews: () ->
    @quantityInput = @$el.find('input[name*="quantity"]')
    @volumeInput = @$el.find('input[name*="volume"]')
    @unitSelect = @$el.find('select[name*="unit"]')
    @barcodeSelect = @$el.find('select[name*="barcode_type"]')

  render: () ->
    @$el.html(JST['batches/sub_batch'](
      sub_batch: @model
      quantity: Mixtio.Bootstrap.SubBatchCounts[@model.get("sub_batch_id")]
      volume: @model.get("volume")
      selected_unit: @model.get("unit") # string representation eg "mL"
      units: Mixtio.Bootstrap.Units
      single_barcode: Mixtio.Bootstrap.SubBatchSingleBarcodes
    ))

    @trigger("render")
    this

  clear: () ->
    @model.clear()
    @render()

  update: () ->
    # selectedId = @consumableTypeSelect.val()
    # consumableType = @consumableTypes.filter((type) -> type.id == parseInt(selectedId))[0]
    #
    # lot = consumableType?.get('latest_lot')
    # if lot?
    #   @numberInput.val(lot.number)
    #   @kitchenSelect.val(lot.kitchen_id)
    # else
    #   @numberInput.val("")
    #   @kitchenSelect.val(null)

    this


  close: (e) ->
    e.preventDefault()
    @$el.remove()
    @collection.remove(@model)
