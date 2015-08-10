FactoryGirl.define do
  factory :reagent_type do
    sequence(:name) {|n| "Reagent Type #{n}" }
  end

end
