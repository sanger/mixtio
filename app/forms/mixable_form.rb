module MixableForm

  extend ActiveSupport::Concern

  included do

    attr_accessor :mixture_criteria

    def mixture_criteria
      @mixture_criteria ||= []
    end

    def mixtures
      mixture_criteria.map do |mixture_criteria|
        ing_params = mixture_criteria.slice(:consumable_type_id, :number, :kitchen_id)
        ing = Ingredient.find_by(ing_params) || Lot.create(ing_params)
        Mixture.new(ingredient: ing, quantity: mixture_criteria[:quantity], unit_id: mixture_criteria[:unit_id])
      end
    end

    validate do
      mixture_criteria.each do |mixture_criteria|
        errors[:ingredient] << "consumable type can't be empty" if mixture_criteria[:consumable_type_id].empty?
        errors[:ingredient] << "supplier can't be empty" if mixture_criteria[:kitchen_id].empty?
        quantity = mixture_criteria[:quantity]
        unit_id = mixture_criteria[:unit_id]
        errors[:ingredient] << "invalid unit" if unit_id.present? && !Unit.exists?(unit_id)
        errors[:ingredient] << "invalid quantity #{quantity}" if quantity.present? && quantity.to_f <= 0
        errors[:ingredient] << "cannot specify unit without quantity" if unit_id.present? && !quantity.present?

        if Team.exists?(mixture_criteria[:kitchen_id]) && !Batch.exists?(number: mixture_criteria[:number], kitchen_id: mixture_criteria[:kitchen_id])
          errors[:ingredient] << "with number #{mixture_criteria[:number]} could not be found"
        end

      end
    end

  end

end