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

  describe '#follows_recipe' do
    let(:units) { ['bags', 'bins', 'buckets'].map { |unitname| create(:unit, name: unitname) } }
    let(:kitchens) { ['alpha', 'beta', nil].map { |code| create(:kitchen, product_code: code) } }
    let(:consumable_types) { (1..3).map { create(:consumable_type) } }
    let(:quantities) { [10,11,12] }
    
    let(:batch_kitchens) { kitchens }
    let(:batch_ingredient_consumable_types) { consumable_types }
    let(:batch_quantities) { quantities }

    let(:ct) do
      # Need a recipe with units and quantities and product codes etc.
      ct = create(:consumable_type)
      ingredients = consumable_types.zip(kitchens).map { |cti,kitchen| create(:lot, kitchen: kitchen, consumable_type: cti) }
      quantities = [10,11,12]
      ingredients.zip(units, quantities).each do |ingredient, unit, quantity|
        create(:mixture, mixable: ct, unit: unit, quantity: quantity, ingredient: ingredient)
      end
      ct.reload
    end

    let(:batch) do
      b = build(:batch, consumable_type: ct)
      ingredients = batch_ingredient_consumable_types.zip(batch_kitchens).map { |cti,kitchen| create(:lot, kitchen: kitchen, consumable_type:cti) }
      quantities = [10,11,12]
      mixtures = ingredients.zip(units, batch_quantities).map do |ingredient, unit, quantity|
        build(:mixture, mixable: b, unit: unit, quantity: quantity, ingredient: ingredient)
      end
      b.mixtures = mixtures.reverse
      b
    end

    context 'when consumable type has no recipe' do
      let(:ct) { consumable_types.first }

      context 'when the batch has no ingredients' do
        let(:batch) { build(:batch, consumable_type: ct) }
        it { expect(batch.follows_recipe).to eq(true) }
      end
      context 'when the batch has ingredients' do
        it { expect(batch.follows_recipe).to eq(true) }
      end
    end

    context 'when the consumable type has a recipe' do
      context 'when the batch has no ingredients' do
        let(:batch) { build(:batch, consumable_type: ct) }
        it { expect(batch.follows_recipe).to eq(false) }
      end

      context 'when the batch has matching ingredients' do
        it { expect(batch.follows_recipe).to eq(true) }
      end

      context 'when the batch has an ingredient with a different product code' do
        let(:batch_kitchens) do
          ks = kitchens.dup
          ks[1] = create(:kitchen, name: ks[1].name, product_code: 'gamma')
          ks
        end
        it { expect(batch.follows_recipe).to eq(false) }
      end

      context 'when the batch has an ingredient with a different quantity' do
        let(:batch_quantities) { [10,20,11] }
        it { expect(batch.follows_recipe).to eq(false) }
      end

      context 'when the batch has an ingredient with a different consumable type' do
        let(:batch_ingredient_consumable_types) do
          cts = consumable_types.dup
          cts[1] = create(:consumable_type)
          cts
        end
        it { expect(batch.follows_recipe).to eq(false) }
      end
    end
  end

end
