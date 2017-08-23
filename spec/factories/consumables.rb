FactoryGirl.define do
  factory :consumable do
    batch { create(:batch_with_ingredients) }
    volume 1.1
    unit 'mL'
    sub_batch_id 1
  end

end
