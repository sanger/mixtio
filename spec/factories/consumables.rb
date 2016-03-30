FactoryGirl.define do
  factory :consumable do
    batch { create(:batch_with_ingredients) }
  end

end