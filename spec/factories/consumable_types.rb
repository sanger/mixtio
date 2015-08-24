FactoryGirl.define do
  factory :consumable_type do
    sequence(:name) {|n| "consumable Type #{n}" }
  end

end
