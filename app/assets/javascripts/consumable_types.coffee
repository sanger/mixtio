Object.values = (obj) => Object.keys(obj).map( (key) => obj[key])

String.prototype.capitalize = (str) -> this.charAt(0).toUpperCase() + this.slice(1)

class ConsumableTypeSelect

  constructor: (consumableType) ->
    @consumableType = $(consumableType)
    @consumableName = $('#consumable_name')
    @expiryDateElem = $('#consumable_expiry_date')
    @loadIngredientsLink = $("[data-behavior~=load-ingredients]").first()
    @ingredientsTag = $("[data-output~=ingredients-list]").first()
    @addListeners()

  addListeners: () ->
    @consumableType.on("change", @consumable_type_changed)
    @loadIngredientsLink.on("click", @loadIngredients)

  consumable_type_changed: (e) =>
    return if @consumableType.val() is ""

    consumableType = new ConsumableType({id: @consumableType.val()})

    consumableType.fetch()
      .then(() =>
        @set_expiry_date(consumableType.get('expiry_date_from_today'))
        @set_name(consumableType.get('name'))
      )

  set_name: (name) =>
    @consumableName.val(name)

  set_expiry_date: (date) =>
    @expiryDateElem.val(date)

  loadIngredients: (event) =>
    event.preventDefault()
    return if @consumableType.val() is ""
    consumableType = new ConsumableType({id: @consumableType.val()})
    consumableType.fetch()
      .then(() =>
        @addIngredients(consumableType.get('latest_consumables'))
      )

  addIngredients: (ingredients) =>
    unless @ingredientsTag.is(':visible') or @ingredientsTag.find('table').length
      html = $('<table/>')
      html.append(@createRow(@humaniseTitles(Object.keys(ingredients[0])), "th"))
      for ingredient in ingredients
         html.append(@createRow(Object.values(ingredient), "td"))
      @ingredientsTag.append("<table>" + html.html() + "</table>")
    @ingredientsTag.toggle()

  createRow: (items, tag) =>
    $('<tr/>').append(
      $.map(items, (s) =>
        "<" + tag + ">" + @padNullString(s) + "<" + tag + "/>"
        ).join('')
      )

  humaniseTitles: (items) ->
    $.map(items, (s) ->
      s.capitalize().replace('_', ' ')
      )

  padNullString: (str) ->
    if str == null then "&nbsp;" else str


jQuery ->
  for consumableType in $("[data-behavior~=consumable-type]")
    new ConsumableTypeSelect consumableType