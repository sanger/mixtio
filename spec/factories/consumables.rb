FactoryGirl.define do
  factory :consumable do
    batch { create(:batch_with_ingredients) }
    volume 1.1
    unit 'mL'
  end

end