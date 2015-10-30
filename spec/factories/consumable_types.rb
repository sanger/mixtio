FactoryGirl.define do
  factory :consumable_type do
    sequence(:name) {|n| "consumable Type #{n}" }
    days_to_keep 33

    factory :consumable_type_with_parents do

      transient do
        parents { FactoryGirl.create_list(:consumable_type, 3)}
      end

      after(:create) do |consumable_type, evaluator|
        consumable_type.add_parents(evaluator.parents)
      end

      factory :consumable_type_with_parents_and_consumables do

        after(:create) do |consumable_type, evaluator|
          consumable_type.parents.each do |parent|
            FactoryGirl.create_list(:consumable, 3, consumable_type: parent)
          end
        end
      end
    end
  end

end
