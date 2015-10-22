FactoryGirl.define do
  factory :consumable_type do
    sequence(:name) {|n| "consumable Type #{n}" }
    days_to_keep 33
  end

end
