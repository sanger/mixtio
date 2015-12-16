FactoryGirl.define do
  factory :user do
    sequence(:username) {|n| "user-#{n}" }
    team
  end

end
