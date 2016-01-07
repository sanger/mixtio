class @BatchForm

  constructor: (@form_el, @ingredients_table) ->
    @consumable_type_el = $('#batch_form_consumable_type_id', @form_el)
    @consumable_expiry_date = $('#batch_form_expiry_date', @form_el)

    @add_listeners()

  add_listeners: () ->
    @consumable_type_el.on('change', (e) => @on_consumable_type_change(e))

  on_consumable_type_change: (e) ->
    return if @consumable_type_el.val() is ""

    consumableType = new ConsumableType({id: @consumable_type_el.val()})
    consumableType.fetch()
      .then(() =>
        @set_expiry_date(consumableType.get('expiry_date_from_today'))
        @set_ingredients(consumableType.get('latest_ingredients'))
      )

  set_expiry_date: (date) ->
    @consumable_expiry_date.val(date)

  set_ingredients: (ingredients) ->
    @ingredients_table.set_ingredients(ingredients)

  selected_consumable_type: () ->
    $("option:selected", @consumable_type_el).text()