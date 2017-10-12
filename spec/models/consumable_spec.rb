require 'rails_helper'

RSpec.describe Consumable, type: :model do

  before :each do
    @batch = create(:batch)
  end

  it "should generate a barcode after creation" do
    @batch.sub_batches << create(:sub_batch, volume: 100, unit: 'µL')
    consumable = create(:consumable, sub_batch: @batch.sub_batches.first)
    expect(consumable.barcode).to eq("RGNT_#{consumable.id}")
  end

  it "should not be valid without being part of a sub-batch" do
    expect(build(:consumable, sub_batch: nil)).to_not be_valid
  end

  it "should be able to return a collection by name (ignoring case)" do
    expect(Consumable).to respond_to(:order_by_name)
  end

  it "should have a display volume" do
    @batch.sub_batches << create(:sub_batch, volume: 100, unit: 'µL')
    @batch.sub_batches.first.consumables = create_list(:consumable, 1, sub_batch: @batch.sub_batches.first)
    consumable = @batch.sub_batches.first.consumables.first
    expect(consumable.display_volume).to eql('100µL')
  end

  it "should show fractional volume when given one" do
    @batch.sub_batches << create(:sub_batch, volume: 100.05, unit: 'µL')
    @batch.sub_batches.first.consumables = create_list(:consumable, 1, sub_batch: @batch.sub_batches.first)
    consumable = @batch.sub_batches.first.consumables.first
    expect(consumable.display_volume).to eql('100.05µL')
  end
end
