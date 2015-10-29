class @EditableParents

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

  setParentIds: () =>
    @parent_ids.val($.map($("select", @parent), (s) -> $(s).val() ).join(","))

  addNewParent: (element, e) =>
    e.preventDefault()
    @parent.append("<li>" + $(element.closest('li')).html() + "</li>")

  removeParent: (element, e) =>
    e.preventDefault()
    $(element.closest('li')).remove()