class @IngredientsTable

  constructor: (@table_el) ->
    @table_el.on('click', '[data-behavior~=remove_row]', (e) ->
      e.preventDefault()
      $row = $(this).closest('tr')
      $row.fadeOut(400, () => $row.remove())
    )

  add_ingredient: (ingredient) ->
    $row = $(ingredient_template)

    if ingredient?
      for attr, value of ingredient
        $("[name*='#{attr}']", $row).val(value)

    $('tr:last', @table_el).after($row)

  add_ingredients: (ingredients) ->
    @add_ingredient ingredient for ingredient in ingredients

  set_ingredients: (ingredients) ->
    @clear_ingredients()
    @add_ingredients ingredients

  clear_ingredients: () ->
    $('tr', @table_el).slice(1).remove()