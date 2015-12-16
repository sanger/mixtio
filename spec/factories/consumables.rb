FactoryGirl.define do
  factory :consumable do
    sequence(:name) {|n| "Consumable #{n}" }
    batch
    after(:create) {|consumable| consumable.lots = [create(:lot)]}
  end

end