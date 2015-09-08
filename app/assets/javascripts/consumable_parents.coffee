class ConsumableParents

  constructor: (parent) ->
    @parent     = $(parent)
    @parent_ids = @parent.children("[data-id~=parent_ids]")
    @addListeners()

  addListeners: () ->
    self = @
    @parent.on('change', 'select', @setParentIds)
    @parent.on('click', "[data-behavior~=add_parent]", (e) ->
      self.addNewParent($(this), e)
    )

  setParentIds: (e) =>
    @parent_ids.val($.map($("select", @parent), (s) ->
      $(s).val()
    ).join(","))

  addNewParent: (element, e) =>
    e.preventDefault()
    @parent.append($(element.closest('li')).wrap("<li></li>").html())

jQuery ->
  for parent in $("[data-behavior~=parents]")
    new ConsumableParents parent