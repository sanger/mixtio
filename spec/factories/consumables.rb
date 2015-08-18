FactoryGirl.define do
  factory :consumable do
    sequence(:name) {|n| "consumable #{n}" }
    expiry_date { 1.month.from_now }
    lot_number 1
    arrival_date { Date.today }
    supplier 'Stark Inc.'
    consumable_type
  end

end
