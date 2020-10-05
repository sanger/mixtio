FactoryBot.define do
  factory :audit do

    transient do
      consumable_type { create(:consumable_type) }
    end

    auditable_id { consumable_type.id }
    auditable_type { consumable_type.class }
    action { "create" }
    record_data { consumable_type }
    user

  end

end
