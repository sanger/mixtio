require 'rails_helper'
require Rails.root.join 'spec/models/concerns/activatable.rb'
require Rails.root.join 'spec/models/concerns/mixable.rb'

RSpec.describe ConsumableType, type: :model do

  it_behaves_like "mixable" do
    let(:no_mixtures) { create(:consumable_type) }
    let(:with_mixtures) { create(:consumable_type_with_recipe) }
  end

  it "should not be valid without a name" do
    expect(build(:consumable_type, name: nil)).to_not be_valid
  end

  it "should not be valid without a unique name" do
    consumable_type = create(:consumable_type)
    expect(build(:consumable_type, name: consumable_type.name)).to_not be_valid
  end

  it "should not be valid without a days_to_keep greater or equal to than zero" do
    expect(build(:consumable_type, days_to_keep: 0)).to be_valid
    expect(build(:consumable_type, days_to_keep: -1)).to_not be_valid
    expect(build(:consumable_type, days_to_keep: 'abc')).to_not be_valid
    expect(build(:consumable_type, days_to_keep: '')).to be_valid
    expect(build(:consumable_type, days_to_keep: nil)).to be_valid
  end

  it 'should return the latest lot of the consumable type' do
    consumable_type = create(:consumable_type)
    expect(consumable_type.latest_lot).to be_nil

    lot_1 = create(:lot, consumable_type: consumable_type)
    lot_2 = create(:lot, consumable_type: consumable_type)
    expect(consumable_type.latest_lot).to eq(lot_2)
  end

  it "should be able to return a collection by name (ignoring case)" do
    expect(ConsumableType).to respond_to(:order_by_name)
  end

  it "should be auditable" do
    expect(build(:consumable_type)).to respond_to(:audits)
  end

  describe '#prefill_data' do

    describe ':ingredients' do
      context 'when there are no mixtures' do
        it 'returns an empty list' do
          expect(create(:consumable_type).prefill_data[:ingredients]).to eq([])
        end
      end

      context 'when there are mixtures' do
        it 'fills ingredients with the mixture criteria' do
          consumable_type = create(:consumable_type_with_recipe)
          expect(consumable_type.prefill_data[:ingredients]).to eq(consumable_type.mixture_criteria)
        end
      end
    end

    describe ':sub_batch_unit' do
      context 'when there are no batches' do
        it 'returns nil' do
          expect(create(:consumable_type).prefill_data[:sub_batch_unit]).to eq(nil)
        end
      end

      context 'when there are batches' do
        it 'returns the latest SubBatch\'s unit' do
          batch = create(:batch_with_consumables)
          consumable_type = batch.consumable_type
          expect(consumable_type.prefill_data[:sub_batch_unit]).to eq(batch.sub_batches.first.unit)
        end
      end

    end
  end

  it_behaves_like "activatable"
end
