class ConsumableTypeSelect

  constructor: (consumable_type) ->
    @consumable_type = $(consumable_type)
    @expiry_date_elem = $('#consumable_expiry_date')
    @addListeners()

  addListeners: () ->
    @consumable_type.on("change", @update_expiry_date)

  update_expiry_date: (e) =>
    return if @consumable_type.val() is ""

    consumable_type = new ConsumableType({id: @consumable_type.val()})

    consumable_type.fetch()
      .then(() =>
        @set_expiry_date(consumable_type.get('expiry_date_from_today'))
      )

  set_expiry_date: (date) =>
    @expiry_date_elem.val(date)

jQuery ->
  for consumable_type in $("[data-behavior~=consumable_type]")
    new ConsumableTypeSelect consumable_type