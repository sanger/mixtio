require 'rails_helper'

RSpec.describe Consumable, type: :model do

  it "should generate a barcode after creation" do
    consumable = create(:consumable, name: 'My consumable')
    expect(consumable.barcode).to eq("mx-#{consumable.id}")
  end

  it "should assign lots correctly" do
    consumable = create(:consumable)
    lots       = create_list(:lot, 3)

    consumable.lots = lots
    expect(consumable.lots).to eq(lots)
  end

  it "should not be valid without being part of a batch" do
    expect(build(:consumable, batch: nil)).to_not be_valid
  end

  it "should be able to return a collection by name (ignoring case)" do
    expect(Consumable).to respond_to(:order_by_name)
  end

end
