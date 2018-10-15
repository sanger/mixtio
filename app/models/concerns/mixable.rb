##
# Concern to be included in a model that has mixtures
module Mixable

  extend ActiveSupport::Concern

  included do
    has_many :mixtures, as: :mixable

    # Converts the Mixtures on the including Mixable into criteria (for use in a Mixable form)
    def mixture_criteria
      mixtures.map do |mixture|
        ingredient = mixture.ingredient
        {
          consumable_type_id: ingredient.consumable_type_id,
          number: ingredient.consumable_type.latest_lot&.number,
          kitchen_id: ingredient.kitchen_id,
          quantity: mixture.quantity,
          unit_id: mixture.unit_id,
        }
      end
    end
  end
end
