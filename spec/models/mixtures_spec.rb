require 'rails_helper'

RSpec.describe Mixture, type: :model do

  let(:unit) { create(:unit) }
  let(:ingredient) { create(:ingredient) }
  let(:batch) { create(:batch) }

  it "can have a unit and quantity" do
    expect(build(:mixture, ingredient: ingredient, mixable: batch, quantity: 20, unit: unit)).to be_valid
  end

  it "can have no unit nor quantity" do
    expect(build(:mixture, ingredient: ingredient, mixable: batch)).to be_valid
  end

  describe 'Mixture#from_params' do

    context 'when an Ingredient with the given params can be found' do
      let(:ingredient) { create(:batch) }
      let(:unit) { create(:unit) }

      let(:mixture_params) do
        MixtureParameters.new(
          consumable_type_id: ingredient.consumable_type_id,
          number: ingredient.number,
          kitchen_id: ingredient.kitchen_id,
          quantity: 5.0,
          unit_id: unit.id
        )
      end

      it 'returns a new Mixture with that Ingredient' do
        mixture = Mixture.from_params(mixture_params)
        expect(mixture.ingredient).to eq(ingredient)
        expect(mixture.quantity).to eql(5.0)
        expect(mixture.unit).to eq(unit)
      end

    end

    context 'when no Ingredient with the given params can be found' do
      let(:consumable_type) { create(:consumable_type) }
      let(:kitchen) { create(:supplier) }
      let(:unit) { create(:unit) }

      let(:mixture_params) do
        MixtureParameters.new(
            consumable_type_id: consumable_type.id,
            number: "TEST LOT 1",
            kitchen_id: kitchen.id,
            quantity: 5.0,
            unit_id: unit.id
        )
      end

      it 'returns a new Mixture with a new Lot as the Ingredient' do
        mixture = Mixture.from_params(mixture_params)
        ingredient = mixture.ingredient
        expect(ingredient).to be_instance_of(Lot)
        expect(ingredient.consumable_type_id).to eql(consumable_type.id)
        expect(ingredient.number).to eql("TEST LOT 1")
        expect(ingredient.kitchen_id).to eql(kitchen.id)
        expect(mixture.quantity).to eql(5.0)
        expect(mixture.unit).to eql(unit)
      end

    end

  end

end
