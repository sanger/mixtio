class Mixtio.Models.Ingredient extends Backbone.Model

  equalTo: (other) ->
    @get('consumable_type_id') == other.get('consumable_type_id') &&
    @get('kitchen_id') == other.get('kitchen_id') &&
    @get('quantity') == other.get('quantity') &&
    @get('unit_id') == other.get('unit_id')