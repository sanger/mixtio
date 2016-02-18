FactoryGirl.define do
  factory :ingredient do
    kitchen
    consumable_type
    sequence(:number) { |n| "Ingredient #{n}" }

    factory :batch, parent: :ingredient, class: 'Batch' do
      expiry_date { 33.days.from_now }
    end

    factory :batch_with_consumables, parent: :batch do
      consumables { build_list :consumable, 3 }
    end

    factory :lot, class: 'Lot' do
    end
  end
end
