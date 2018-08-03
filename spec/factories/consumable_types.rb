FactoryBot.define do
  factory :consumable_type do
    sequence(:name) { |n| "Consumable Type #{n}" }
    days_to_keep 33
    storage_condition "LN2"
  end
end
