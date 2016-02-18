FactoryGirl.define do
  factory :user do
    sequence(:username) {|n| "User #{n}" }
    team
  end
end
