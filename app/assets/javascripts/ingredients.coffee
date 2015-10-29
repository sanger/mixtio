class IngredientsList extends @EditableParents

jQuery ->
  for ingredients in $("[data-behavior~=ingredients]")
    new IngredientsList ingredients