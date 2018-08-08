require 'rails_helper'
require Rails.root.join 'spec/models/concerns/activatable_spec.rb'

RSpec.describe ConsumableType, type: :model do

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

  it "should return the latest ingredient for each item in its recipe" do
    consumable_type = create(:consumable_type)
    expect(consumable_type.latest_ingredients).to be_empty

    batch_1 = create(:batch_with_ingredients, consumable_type: consumable_type)
    batch_2 = create(:batch_with_ingredients, consumable_type: consumable_type)
    expect(consumable_type.latest_ingredients).to eq(batch_2.ingredients)
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

  describe '#ingredients_prefill' do
    context 'when there is no previous batch' do
      it { expect(create(:consumable_type).ingredients_prefill).to be_empty }
    end

    context 'when there is a previous batch and it contains the latest lots' do
      it 'should return the ingredient data from the latest batch' do
        ct = create(:consumable_type)
        cx = create(:consumable_type)
        batch_1 = create(:batch_with_ingredient_quantities, consumable_type: ct)
        batch_2 = create(:batch_with_ingredient_quantities, consumable_type: ct)
        batch_x = create(:batch_with_ingredient_quantities, consumable_type: cx)
        expected = batch_2.mixtures.map do |mx|
          {
            consumable_type_id: mx.ingredient.consumable_type_id,
            number: mx.ingredient.number,
            kitchen_id: mx.ingredient.kitchen_id,
            quantity: mx.quantity,
            unit_id: mx.unit_id,
          }
        end
        expect(ct.ingredients_prefill).to eq expected
      end
    end

    context 'when there are newer lots of the ingredients used in other recipes' do
      it 'should return the latest lots of the ingredients' do
        ct = create(:consumable_type)
        cx = create(:consumable_type)
        batch_1 = create(:batch_with_ingredient_quantities, consumable_type: ct)
        batch_2 = create(:batch_with_ingredient_quantities, consumable_type: ct)
        batch_x = create(:batch_with_ingredient_quantities, consumable_type: cx)
        ing_type = batch_2.ingredients.first.consumable_type
        other_lot = create(:lot, consumable_type: ing_type, number: 999)
        expected = batch_2.mixtures.map do |mx|
          {
            consumable_type_id: mx.ingredient.consumable_type_id,
            number: mx.ingredient.number,
            kitchen_id: mx.ingredient.kitchen_id,
            quantity: mx.quantity,
            unit_id: mx.unit_id,
          }
        end
        expected[0][:number] = other_lot.number
        expected[0][:kitchen_id] = other_lot.kitchen_id
        expect(ct.ingredients_prefill).to eq expected
      end
    end
  end

  it_behaves_like "activatable"
end
