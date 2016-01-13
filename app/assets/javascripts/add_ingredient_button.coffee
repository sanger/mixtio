class @AddIngredientButton

  constructor: (@button_el, @ingredients_table, @scan_input) ->
    @button_el.on("click", (e) =>
      e.preventDefault()
      if @scan_input? and @scan_input.value() isnt ""
        @scan_input.fetch_and_add_ingredient()
      else
        @ingredients_table.add_ingredient()
    )