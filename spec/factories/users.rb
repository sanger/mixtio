FactoryGirl.define do
  factory :user do
    sequence(:username) {|n| "user-#{n}" }
    team

    factory :administrator, class: "Administrator" do
    end

    factory :scientist, class: "Scientist" do
    end

    factory :guest, class: "Guest" do
    end

  end

end
