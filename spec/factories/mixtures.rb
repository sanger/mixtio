FactoryBot.define do
  factory :mixture do
    ingredient { create(:lot, consumable_type_team: mixable.is_a?(ConsumableType) ? mixable.team : nil) }
    mixable { create(:batch) }

    factory :mixture_with_quantity do
      quantity { 3.14 }
      unit
    end

  end

end
