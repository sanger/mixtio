FactoryBot.define do
  factory :consumable_type do
    sequence(:name) { |n| "Consumable Type #{n}" }
    days_to_keep { 33 }
    storage_condition { "LN2" }
    team

    factory :consumable_type_with_recipe do
      transient do
        recipe_size { 5 }
      end

      after(:create) do |consumable_type, evaluator|
        create_list(:mixture, evaluator.recipe_size, mixable: consumable_type)
      end
    end
  end
end
