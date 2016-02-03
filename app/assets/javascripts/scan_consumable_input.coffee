class @ScanConsumableInput

  constructor: (@input_el, @ingredients_table) ->
    @input_el.on("keydown", (e) =>
      return unless e.keyCode is 9 or e.keyCode is 13 # Tab or Return
      e.preventDefault()
      @fetch_and_add_ingredient()
    )

  fetch_and_add_ingredient: () =>
    return if @value() is ""
    consumable = new Consumable(barcode: @value())
    lot = {}
    consumable.fetch()
      .then(
        () =>
          lot = new Lot(id: consumable.get("lot").id)
          lot.fetch()
      ).then(
        () =>
          ingredient =
            consumable_type_id: lot.get("consumable_type").id
            supplier_id: lot.get("supplier").id
            name: lot.get("name")

          @ingredients_table.add_ingredient(ingredient)
          @value('')

        (e) => @displayError(e.message)
      )

  value: (value) ->
    @input_el.val(value) if value?
    @input_el.val()

  displayError: (message) ->
    $error = $("<div class=\"alert alert-danger\" role=\"alert\">" + message + "</div>")

    @input_el.closest("div.row")
      .prepend($error)

    setTimeout((() ->
      $error.fadeOut(400, () -> $error.remove()))
      , 4000
    )
