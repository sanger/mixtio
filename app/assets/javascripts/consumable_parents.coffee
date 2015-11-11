class ConsumableParents extends @EditableParents

  addListeners: () ->
    self = @
    super

    @parent.on('blur', "[data-behavior~=scan-parent-barcode]", (e) ->
      unless $(this).val() is ""
        consumable = new Consumable({barcode: $(this).val()})

        parentSelect = $(this).closest("[data-behavior~=parent-select]").find("[data-output~=parent-id]")
        consumable.fetch()
          .then(() =>
            self.setParentSelect(parentSelect, consumable.get('id'))
            $(this).val('')
          )
      )

  setParentSelect: (parentSelect, val) =>
    $('option', parentSelect).filter(() ->
      parseInt($(this).val()) is val
    ).prop("selected", true)
    @setParentIds()

jQuery ->
  for parent in $("[data-behavior~=parents]")
    new ConsumableParents parent