FactoryGirl.define do
  factory :consumable_type do
    sequence(:name) {|n| "consumable Type #{n}" }
    days_to_keep 33

    factory :consumable_type_with_ingredients do

      transient do
        ingredients { FactoryGirl.create_list(:consumable_type, 3)}
      end

      after(:create) do |consumable_type, evaluator|
        consumable_type.ingredients = evaluator.ingredients
      end

      factory :consumable_type_with_ingredients_with_lots do

        after(:create) do |consumable_type, evaluator|
          consumable_type.ingredients.each do |ingredient|
            FactoryGirl.create_list(:lot, 3, consumable_type: ingredient)
          end
        end
      end
    end
  end

end
