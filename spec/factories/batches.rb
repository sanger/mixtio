FactoryGirl.define do
  factory :batch do
    expiry_date { 33.days.from_now }
    arrival_date { 2.days.from_now }
    lot
  end

end
