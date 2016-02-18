FactoryGirl.define do
  factory :consumable_type do
    sequence(:name) {|n| "Consumable Type #{n}" }
    days_to_keep 33
    freezer_temperature "LN2"

    factory :consumable_type_with_recipe_ingredients do

      transient do
        recipe_ingredients { FactoryGirl.create_list(:consumable_type, 3) }
      end

      after(:create) do |consumable_type, evaluator|
        consumable_type.recipe_ingredients = evaluator.recipe_ingredients
      end

      factory :consumable_type_with_ingredients do

        after(:create) do |consumable_type, evaluator|
          consumable_type.recipe_ingredients.each do |recipe_ingredient|
            FactoryGirl.create_list(:lot, 3, consumable_type: recipe_ingredient)
          end
        end
      end

    end
  end

end
