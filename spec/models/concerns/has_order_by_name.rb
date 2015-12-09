require "rails_helper"

RSpec.describe HasOrderByName, type: :model do

  with_model :TestModel do
    table do |t|
      t.string :name
    end

    model do
      include HasOrderByName
    end

  end

  let!(:models) { %w{Indigo alpha Bravo zulu hotel Foxtrot}.each { |name| TestModel.create(name: name) }}

  it "should return models ordered by name" do
    expected_order = %w{alpha Bravo Foxtrot hotel Indigo zulu}
    expect(TestModel.order_by_name.collect(&:name)).to eq(expected_order)
  end

end