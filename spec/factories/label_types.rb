FactoryGirl.define do
  factory :label_type do
    sequence(:name) { |i| "Label Type #{i}"}
    sequence(:external_id) { |n| n }
  end

end
