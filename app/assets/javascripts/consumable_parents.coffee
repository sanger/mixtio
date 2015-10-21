class ConsumableParents

  constructor: (parent) ->
    @parent        = $(parent)
    @parent_ids    = @parent.children("[data-id~=parent_ids]")
    @addListeners()

  addListeners: () ->
    self = @
    @parent.on('change', 'select', @setParentIds)
    @parent.on('click', "[data-behavior~=add_parent]", (e) ->
      self.addNewParent($(this), e)
    )
    @parent.on('click', "[data-behavior~=remove_parent]", (e) ->
      self.removeParent($(this), e)
      self.setParentIds()
    )
    @parent.on('blur', "[data-behavior~=scan_parent_barcode]", (e) ->
      consumable = new Consumable({barcode: $(this).val()})

      parent_select = $(this).siblings('select')

      consumable.fetch()
        .then(() =>
          self.setParentSelect(parent_select, consumable.get('id'))
          $(this).val('')
        , () => console.error("Something went wroooong!"))
    )

  setParentIds: () =>
    @parent_ids.val($.map($("select", @parent), (s) -> $(s).val() ).join(","))

  setParentSelect: (parent_select, val) =>
    $('option', parent_select).filter(() ->
      parseInt($(this).val()) is val
    ).prop("selected", true)
    @setParentIds()

  addNewParent: (element, e) =>
    e.preventDefault()
    @parent.append("<li>" + $(element.closest('li')).html() + "</li>")

  removeParent: (element, e) =>
    e.preventDefault()
    $(element.closest('li')).remove()


jQuery ->
  for parent in $("[data-behavior~=parents]")
    new ConsumableParents parent