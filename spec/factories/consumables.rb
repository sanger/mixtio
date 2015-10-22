FactoryGirl.define do
  factory :consumable do
    sequence(:name) {|n| "consumable #{n}" }
    expiry_date { 1.month.from_now }
    lot_number { "ln-#{name}" }
    arrival_date { Date.today }
    supplier 'Stark Inc.'
    consumable_type

    factory :consumable_with_parents do

      transient do
        parents { FactoryGirl.create_list(:consumable, 3)}
      end

      after(:create) do |consumable, evaluator|
        consumable.add_parents(evaluator.parents)
      end
    end

    factory :consumable_with_children do
      number_of_children 3
    end
  end

end