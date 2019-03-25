FactoryBot.define do
  factory :ingredient do
    kitchen
    consumable_type
    sequence(:number) { |n| "Ingredient #{n}" }

    factory :batch, parent: :ingredient, class: 'Batch' do
      expiry_date { 33.days.from_now }
      user
    end

    factory :batch_with_consumables, parent: :batch do
      sub_batches { build_list :sub_batch_diff_bacodes, 1 }
    end

    factory :batch_1SB_same_barcode, parent: :batch do
      sub_batches { build_list :sub_batch_same_bacodes, 1 }
    end

    factory :batch_with_ingredients, parent: :batch do
      mixtures { build_list :mixture, 3 }
    end

    factory :batch_with_ingredient_quantities, parent: :batch do
      mixtures { build_list :mixture_with_quantity, 2 }
    end

    factory :lot, class: 'Lot' do
    end
  end
end
