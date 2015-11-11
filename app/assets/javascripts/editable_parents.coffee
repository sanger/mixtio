class @EditableParents

  constructor: (parent) ->
    @parent        = $(parent)
    @parentIds     = @parent.children("[data-id~=parent-ids]")
    @addListeners()

  addListeners: () ->
    self = @
    @parent.on('change', 'select', @setParentIds)
    @parent.on('click', "[data-behavior~=add-parent]", (e) ->
      self.addNewParent($(this), e)
    )
    @parent.on('click', "[data-behavior~=remove-parent]", (e) ->
      self.removeParent($(this), e)
      self.setParentIds()
    )

  setParentIds: () =>
    @parentIds.val($.map($("select", @parent), (s) -> $(s).val() ).join(","))

  addNewParent: (element, e) =>
    e.preventDefault()
    @parent.append('<ul data-behavior="parent-select">' + $(element.closest("[data-behavior~=parent-select]")).html() + '</ul>')

  removeParent: (element, e) =>
    e.preventDefault()
    $(element.closest("[data-behavior~=parent-select]")).remove()