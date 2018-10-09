require 'rails_helper'
require Rails.root.join 'spec/models/concerns/mixable.rb'

RSpec.describe Batch, type: :model do

  it_behaves_like "mixable" do
    let(:no_mixtures) { create(:batch) }
    let(:with_mixtures) { create(:batch_with_ingredients) }
  end

  it "should not be valid without an expiry date" do
    expect(build(:batch, expiry_date: nil)).to_not be_valid
  end

  it "should not be valid with an expiry date in the past" do
    batch = build(:batch, expiry_date: 1.day.ago)
    expect(batch).to_not be_valid
    expect(batch.errors.messages[:expiry_date]).to include(I18n.t('errors.future_date'))
  end

  it "should create a batch number when created" do
    batch = build(:batch, number: nil)
    batch.save!
    expect(batch.number).to eq("#{batch.kitchen.name.upcase.gsub(/\s/, '')}-#{batch.id}")
  end

  it "should be able to order by created at" do
    batch1 = create(:batch, created_at: 1.day.from_now)
    batch2 = create(:batch, created_at: 3.day.from_now)
    batch3 = create(:batch, created_at: 2.day.from_now)

    expect(Batch.order_by_created_at).to eq([batch2, batch3, batch1])
  end

  it "should assign ingredients correctly" do
    batch = create(:batch)
    ingredients = create_list(:ingredient, 3)

    batch.ingredients = ingredients
    expect(batch.ingredients).to eq(ingredients)
  end

  it "should be auditable" do
    expect(build(:batch)).to respond_to(:audits)
  end

  it "should say single barcode is false if consumable barcodes differ" do
    batch = create(:batch_with_consumables)

    expect(batch.sub_batches.first.single_barcode?).to eq(false)
  end

  it "should say single barcode is true if consumable barcodes are all the same" do
    batch = create(:batch_1SB_same_barcode)

    expect(batch.sub_batches.first.single_barcode?).to eq(true)
  end

  it 'should total the volumes of the consumables' do
    batch = create(:batch)
    batch.sub_batches << create(:sub_batch, volume: 1, unit: 'L')
    batch.sub_batches << create(:sub_batch, volume: 5, unit: 'mL')
    batch.sub_batches << create(:sub_batch, volume: 3, unit: 'mL')

    batch.sub_batches.each do |sub_batch|
      sub_batch.consumables = create_list(:consumable, 5, sub_batch: sub_batch)
    end

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
