require 'rails_helper'

RSpec.describe Batch, type: :model do

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

  it "should require volume" do
    expect(build(:batch, volume: nil)).to_not be_valid
  end
  it "should require volume" do
    expect(build(:batch, unit: nil)).to_not be_valid
  end

  it "should say single barcode is false if consumable barcodes differ" do
    batch = create(:batch_with_consumables)

    expect(batch.single_barcode?).to eq(false)
  end

  it "should say single barcode is true if consumable barcodes are all the same" do
    batch = create(:batch)
    consumable = create(:consumable)
    batch.consumables = (1..3).map { |n| consumable.dup }

    expect(batch.single_barcode?).to eq(true)
  end
end
