FactoryGirl.define do
  factory :printer do
    sequence(:name) { |i| "Printer #{i}"}
  end

end
