class Mixtio.Views.SubBatch extends Backbone.View

  tagName: 'tr'

  id: () ->
    id = @model.get("id")
    if (id != null and id != undefined)
      "sub-batch-" + id
    else
      "sub-batch-new"


  events:
    # Run the close function if the X button is clicked for the row
    'click a[data-behavior~=remove_row]': 'close'
    'change input[name*="quantity"]': 'update'
    'change input[name*="volume"]': 'update'
    'change select[name*="unit"]': 'update'

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
      quantity: @model.get("quantity")
      volume: @model.get("volume")
      selected_unit: @model.get("unit") # string representation eg "mL"
      units: Mixtio.Bootstrap.Units
      single_barcode: @model.get("single_barcode?")
    ))

    @trigger("render")
    this

  clear: () ->
    @model.clear()
    @render()

  update: () ->
    @model.set("quantity": @quantityInput.val(), "volume": @volumeInput.val(), "unit": @unitSelect.val())
    this


  close: (e) ->
    e.preventDefault()
    @$el.remove()
    @collection.remove(@model)
