FactoryBot.define do
  factory :kitchen do

    sequence(:name) {|n| "Kitchen #{n}" }

    factory :supplier, class: 'Supplier' do
      sequence(:name) {|n| "Supplier #{n}" }
    end

    factory :team, class: 'Team' do
      sequence(:name) {|n| "Team #{n}" }
    end

  end
end
