class Mixtio.Collections.Ingredients extends Backbone.Collection

  url: "#{Mixtio.BaseURL}/ingredients"

  model: Mixtio.Models.Ingredient

  findAndSetToLatest: (consumable_types) ->
    jqXHRs = consumable_types.map (consumable_type) =>
      Backbone.sync('read', @, data: { consumable_type_id: consumable_type.id, sort: '-created_at' })

    $.when.apply($, jqXHRs).done(() =>
      @reset _.toArray(arguments).map((arg) ->
        [response, status, jqXHR] = arg
        if response.ingredients.length is 0
          new Mixtio.Models.Ingredient()
        else
          new Mixtio.Models.Ingredient(response.ingredients[0])
      )
    )