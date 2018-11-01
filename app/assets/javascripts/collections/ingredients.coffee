class Mixtio.Collections.Ingredients extends Backbone.Collection

  model: Mixtio.Models.Ingredient

  equalTo: (other) ->
    return false if @length != other.length

    thisSorted  = @sortBy((ingredient) -> ingredient.id)
    otherSorted = other.sortBy((ingredient) -> ingredient.id)

    _.zip(thisSorted, otherSorted).every((ingredients, index) ->
      [thisIngredient, otherIngredient] = ingredients
      thisIngredient.equalTo(otherIngredient)
    )