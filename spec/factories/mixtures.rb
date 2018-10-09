FactoryBot.define do
  factory :mixture do
    ingredient { create(:lot) }
    mixable { create(:batch) }

    factory :mixture_with_quantity do
      quantity 3.14
      unit
    end

  end

end