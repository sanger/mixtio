FactoryBot.define do
  factory :consumable do
    sub_batch
    sequence(:barcode) { |n| "Barcode #{n}"}
  end
end
