FactoryBot.define do
  factory :ingredient do
    kitchen
    consumable_type
    sequence(:number) { |n| "Ingredient #{n}" }

    factory :batch, class: 'Batch' do
      expiry_date { 33.days.from_now }
      user

      transient do
        single_barcode { false }
      end

      after(:build) do |batch, evaluator|
        batch.sub_batches = [build(:sub_batch, batch: batch, barcode_type: evaluator.single_barcode ? "single" : "aliquots")]
      end
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
