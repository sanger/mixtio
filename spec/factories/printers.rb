FactoryBot.define do
  factory :printer do
    sequence(:name) { |i| "Printer #{i}"}
    label_type { create(:label_type) }
    service { "pmb" }
  end

end
