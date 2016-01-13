FactoryGirl.define do
  factory :lot do
    sequence(:name) {|n| "Lot #{n}" }
    supplier
    consumable_type
  end

end
