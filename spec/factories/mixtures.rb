FactoryGirl.define do
  factory :mixture do
    ingredient { create(:lot) }
    batch { create(:batch) }
  end

end