require 'rails_helper'
require Rails.root.join 'spec/models/concerns/mixable.rb'

RSpec.describe Batch, type: :model do

  it_behaves_like "mixable" do
    let(:no_mixtures) { create(:batch) }
    let(:with_mixtures) { create(:batch_with_ingredients) }
  end

  it "should not be valid without a use by date" do
    expect(build(:batch, expiry_date: nil)).to_not be_valid
  end

  it "should not be valid with a use by date in the past" do
    batch = build(:batch, expiry_date: 1.day.ago)
    expect(batch).to_not be_valid
    expect(batch.errors.messages[:expiry_date]).to include(I18n.t('errors.future_date'))
  end

  it "is not valid when sub-batches are invalid" do
    batch = build(:batch)
    batch.sub_batches.build(volume: nil)
    expect(batch.valid?).to be false
  end

  it "should create a batch number when created" do
    batch = build(:batch, number: nil)
    batch.save!
    expect(batch.number).to eq("#{batch.kitchen.name.upcase.gsub(/\s/, '')}-#{batch.id}")
  end

  it "should be auditable" do
    expect(build(:batch)).to respond_to(:audits)
  end

  it "should say single barcode is false if consumable barcodes differ" do
    batch = build(:batch)

    expect(batch.sub_batches.first.single_barcode?).to eq(false)
  end

  it "should say single barcode is true if consumable barcodes are all the same" do
    batch = create(:batch, single_barcode: true)
    expect(batch.sub_batches.first.single_barcode?).to eq(true)
  end

  it 'should total the volumes of the consumables' do
    batch = create(:batch)
    sub_batches = []
    sub_batches << create(:sub_batch, volume: 1, unit: 'L', quantity: 5)
    sub_batches << create(:sub_batch, volume: 5, unit: 'mL', quantity: 5)
    sub_batches << create(:sub_batch, volume: 3, unit: 'mL', quantity: 5)

    batch.sub_batches = sub_batches

    expect(batch.display_volume).to eq('5.04L')
  end

  describe "getters" do
    before :each do
      @batch = create(:batch)
      @batch.sub_batches = [create(:sub_batch, volume: 42, unit: 'mL')]
      @batch.sub_batches.first.consumables = create_list(:consumable, 12, sub_batch: @batch.sub_batches.first)
    end

    context "retrieving the batch size (consumable count)" do
      it "returns the correct value" do
        expect(@batch.size).to eq(12)
      end
    end
  end

end
