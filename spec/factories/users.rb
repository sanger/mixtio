FactoryGirl.define do
  factory :user do
    sequence(:login) {|n| "user-#{n}" }
    swipe_card_id { "swipe-card-id-#{login}" }
    barcode { "barcode-#{login}" }
    team
  end

end
