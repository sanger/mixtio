FactoryGirl.define do
  factory :consumable do
    sequence(:name) {|n| "Consumable #{n}" }
    batch { create(:batch_with_ingredients) }
  end

end