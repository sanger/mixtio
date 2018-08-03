FactoryBot.define do
  factory :sub_batch do
    volume 1.5
    unit "mL"
    project
  end

  factory :sub_batch_diff_bacodes, parent: :sub_batch do
    consumables { build_list :consumable, 3 }
  end

  factory :sub_batch_same_bacodes, parent: :sub_batch do
    consumables { build_list :consumable, 3, barcode: "RGNT-1" }
  end
end
