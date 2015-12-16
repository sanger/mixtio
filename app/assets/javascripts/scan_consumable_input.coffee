class @ScanConsumableInput

  constructor: (@input_el, @ingredients_table) ->
    @input_el.on("keydown", (e) =>
      return unless e.keyCode is 9 or e.keyCode is 13 # Tab or Return
      e.preventDefault()
      @fetch_and_add_ingredient()
    )

  fetch_and_add_ingredient: () =>
    consumable = new Consumable(barcode: @value())
    lot = {}
    consumable.fetch()
      .then(() =>
        lot = new Lot(id: consumable.get("lot").id)
        lot.fetch()
      ).then(() =>
        @ingredients_table.add_ingredient(lot.attributes)
        @value('')
      )

  value: (value) ->
    @input_el.val(value) if value?
    @input_el.val()