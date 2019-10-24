require 'rails_helper'

RSpec.describe MixtureParameters do

  let(:consumable_type_id) { create(:consumable_type).id }
  let(:batch) { create(:batch) }
  let(:kitchen) { create(:kitchen) }
  let(:kitchen_id) { kitchen.id }
  let(:unit) { create(:unit) }
  let(:unit_id) { unit.id }
  let(:quantity) { 5 }

  let(:mixture_params) do
    MixtureParameters.new(
      consumable_type_id: consumable_type_id,
      number: batch.number,
      kitchen_id: kitchen_id,
      unit_id: unit_id,
      quantity: quantity
    )
  end

  describe 'attribute accessors' do
    it 'returns the right attributes' do
      expect(mixture_params.consumable_type_id).to eql(consumable_type_id)
      expect(mixture_params.number).to eql(batch.number)
      expect(mixture_params.kitchen_id).to eql(kitchen_id)
      expect(mixture_params.unit_id).to eql(unit.id)
      expect(mixture_params.quantity).to eql(quantity)
    end
  end

  describe 'validation' do

    context 'when consumable_type_id isn\'t present' do
      let(:consumable_type_id) { nil }

      it 'is invalid' do
        expect(mixture_params).to be_invalid
      end
    end

    context 'when kitchen_id isn\'t present' do
      let(:kitchen_id) { nil }

      it 'is invalid' do
        expect(mixture_params).to be_invalid
      end
    end

    context 'when quantity is present and unit_id isn\'t' do
      let(:unit_id) { nil }

      it 'is invalid' do
        expect(mixture_params).to be_invalid
      end
    end

    context 'when unit_id is present and quantity isn\'t' do
      let(:quantity) { nil }

      it 'is invalid' do
        expect(mixture_params).to be_invalid
      end
    end

    context 'when both quantity and unit_id are not present' do
      let(:unit_id) { nil }
      let(:quantity) { nil }

      it 'is valid' do
        expect(mixture_params).to be_valid
      end
    end

    context 'when quantity is less than 0' do
      let(:quantity) { -1 }

      it 'is invalid' do
        expect(mixture_params).to be_invalid
      end
    end

    context 'when kitchen is a team and batch can not be found' do
      let(:kitchen) { create(:team) }
      let(:batch) { create(:lot) }

      it 'is invalid' do
        expect(mixture_params).to be_invalid
      end
    end

  end

end
