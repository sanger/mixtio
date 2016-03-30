require 'rails_helper'

RSpec.describe Consumable, type: :model do

  it "should generate a barcode after creation" do
    consumable = create(:consumable)
    expect(consumable.barcode).to eq("RGNT_#{consumable.id}")
  end

  it "should not be valid without being part of a batch" do
    expect(build(:consumable, batch: nil)).to_not be_valid
  end

  it "should be able to return a collection by name (ignoring case)" do
    expect(Consumable).to respond_to(:order_by_name)
  end

  it "should have a display volume" do
    expect(build(:consumable, volume: 100, unit: 'μL').display_volume).to eql('100μL')
  end

  it "should have a simple volume" do
    expect(build(:consumable, volume: 100, unit: 'μL').simple_volume).to eql('100uL')
  end

  it "should show fractional volume when given one" do
    expect(build(:consumable, volume: 100.05, unit: 'μL').display_volume).to eql('100.05μL')
  end

  it "should not be valid without a volume" do
    expect(build(:consumable, volume: nil)).to_not be_valid
  end

  it "should not be valid without a unit" do
    expect(build(:consumable, unit: nil)).to_not be_valid
  end
end
