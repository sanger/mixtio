FactoryGirl.define do
  factory :consumable do
    sequence(:name) {|n| "Consumable #{n}" }
    batch
  end

end