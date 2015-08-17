FactoryGirl.define do
  factory :reagent do
    sequence(:name) {|n| "Reagent #{n}" }
    expiry_date { 1.month.from_now }
    lot_number 1
    arrival_date { Date.today }
    supplier 'Stark Inc.'
    reagent_type
  end

end
