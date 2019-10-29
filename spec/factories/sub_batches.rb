FactoryBot.define do
  factory :sub_batch do
    volume 1.5
    unit "mL"
    project
    batch
    barcode_type { "aliquots" }
    quantity { 3 }
  end

end
