class ConsumableParents extends @EditableParents

  addListeners: () ->
    self = @
    super

    @parent.on('blur', "[data-behavior~=scan_parent_barcode]", (e) ->
      unless $(this).val() is ""
        consumable = new Consumable({barcode: $(this).val()})

        parent_select = $(this).siblings('select')
        consumable.fetch()
          .then(() =>
            self.setParentSelect(parent_select, consumable.get('id'))
            $(this).val('')
          )
      )

  setParentSelect: (parent_select, val) =>
    $('option', parent_select).filter(() ->
      parseInt($(this).val()) is val
    ).prop("selected", true)
    @setParentIds()

jQuery ->
  for parent in $("[data-behavior~=parents]")
    new ConsumableParents parent