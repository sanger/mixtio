FactoryGirl.define do
  factory :reagent do
    sequence(:name) {|n| "Reagent #{n}" }
    expiry_date { 1.month.from_now }
  end

end
