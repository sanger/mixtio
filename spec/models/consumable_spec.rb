require 'rails_helper'

RSpec.describe Consumable, type: :model do

  before :each do
    @batch = create(:batch)
  end

  it "should generate a barcode after creation" do
    @batch.sub_batches << create(:sub_batch, volume: 100, unit: 'µL')
    consumable = create(:consumable, sub_batch: @batch.sub_batches.first)
    expect(consumable.barcode).to_not be_nil
  end

  it "should not be valid without being part of a sub-batch" do
    expect(build(:consumable, sub_batch: nil)).to_not be_valid
  end

end
