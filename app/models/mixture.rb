class Mixture < ActiveRecord::Base
  belongs_to :ingredient
  belongs_to :mixable, polymorphic: true
  belongs_to :unit, optional: true

  # Factory method for creating a new Mixture
  # It will try and find an existing Ingredient based on Consumable Type, Kitchen, and Number
  # If one can't be found it will create a new Lot (which is a type of Ingredient) with those criteria
  # That new Ingredient gets used to create a new Mixture with the given quantity and unit_id
  #
  # @param [MixtureParameters] an instance of MixtureParameters
  # @return [Mixture]
  def self.from_params(mixture_params)
    ingredient_params = {
        consumable_type_id: mixture_params.consumable_type_id,
        number: mixture_params.number,
        kitchen_id: mixture_params.kitchen_id
    }

    ingredient = Ingredient.find_by(ingredient_params) || Lot.create(ingredient_params)

    new(ingredient: ingredient, quantity: mixture_params.quantity, unit_id: mixture_params.unit_id)
  end
end
