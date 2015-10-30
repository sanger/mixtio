class ConsumableTypeSelect

  constructor: (consumable_type) ->
    @consumable_type = $(consumable_type)
    @expiry_date_elem = $('#consumable_expiry_date')
    @loadIngredientsLink = $("[data-behavior~=load_ingredients]").first()
    @IngredientsTag = $("[data-output~=ingredients-list]").first()
    @addListeners()

  addListeners: () ->
    @consumable_type.on("change", @update_expiry_date)
    @loadIngredientsLink.on("click", @loadIngredients)

  update_expiry_date: (e) =>
    return if @consumable_type.val() is ""

    consumable_type = new ConsumableType({id: @consumable_type.val()})

    consumable_type.fetch()
      .then(() =>
        @set_expiry_date(consumable_type.get('expiry_date_from_today'))
      )

  set_expiry_date: (date) =>
    @expiry_date_elem.val(date)

  loadIngredients: (event) =>
    event.preventDefault()
    return if @consumable_type.val() is ""
    consumable_type = new ConsumableType({id: @consumable_type.val()})
    consumable_type.fetch()
      .then(() =>
        @addIngredients(consumable_type.get('latest_consumables'))
      )

  addIngredients: (ingredients) =>
    html = $('<table/>')
    for ingredient in ingredients
      tr = $('<tr/>')
      for key in Object.keys(ingredient)
        tr.append("<td>" + ingredient[key] + "</td>")
       html.append(tr)
    @IngredientsTag.append("<table>" + html.html() + "</table>")

jQuery ->
  for consumable_type in $("[data-behavior~=consumable_type]")
    new ConsumableTypeSelect consumable_type