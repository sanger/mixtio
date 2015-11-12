class @EditableParents

  constructor: (parent) ->
    @parent        = $(parent)
    @parentIds     = @parent.children("[data-id~=parent-ids]")
    @parentSelect  = @parent.children("[data-behavior~=parent-select]")
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
    @parentSelect.append("<ul data-behavior='parent'>" + @parentSelect.children("ul").last().html() + "</ul>")
    @parentSelect.find("select:last option[value='']").attr('selected', true)

  removeParent: (element, e) =>
    e.preventDefault()
    $(element.closest("[data-behavior~=parent]")).remove()