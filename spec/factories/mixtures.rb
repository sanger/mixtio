FactoryBot.define do
  factory :mixture do
    ingredient { create(:lot) }
    batch { create(:batch) }

    factory :mixture_with_quantity do
      ingredient { create(:lot) }
      batch { create(:batch) }
      quantity 3.14
      unit { create(:unit) }
    end

  end

end