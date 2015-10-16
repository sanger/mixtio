FactoryGirl.define do
  factory :user do
    sequence(:login) {|n| "user-#{n}" }
    swipe_card_id { "swipe-card-id-#{login}" }
    barcode { "barcode-#{login}" }
    team

    factory :administrator, class: "Administrator" do
    end

    factory :scientist, class: "Scientist" do
    end

    factory :guest, class: "Guest" do
    end

  end

end
