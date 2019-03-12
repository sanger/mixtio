require 'rails_helper'

RSpec.describe Batches::Index do

  let(:consumable_type) { create(:consumable_type) }
  let(:consumable_type_id) { consumable_type.id }
  let(:created_after) { '01/01/2019' }
  let(:created_before) { '01/04/2019' }
  let(:page) { 1 }
  let(:batch_params) do
    {
      consumable_type_id: consumable_type_id,
      created_after: created_after,
      created_before: created_before,
      page: page
    }
  end

  let(:params) { ActionController::Parameters.new(batch_params) }
  let(:batches_index) { Batches::Index.new(params) }

  describe '#initialization' do

    it 'sets consumable_type_id' do
      expect(batches_index.consumable_type_id).to eql(consumable_type_id)
    end

    it 'sets created_after' do
      expect(batches_index.created_after).to eql(created_after.to_date)
    end

    it 'sets created_before' do
      expect(batches_index.created_before).to eql(created_before.to_date)
    end

  end

  describe '#show_filters?' do

    context 'when none of the parameters are set' do
      let(:batch_params) { {} }

      it 'is false' do
        expect(batches_index.show_filters?).to be false
      end
    end

    context 'when any of the parameters are set' do
      it 'is true' do
        expect(batches_index.show_filters?).to be true
      end
    end

  end

  describe '#batches' do

    context 'consumable_type_id' do
      let(:created_after) { nil }
      let(:created_before) { nil }
      let(:expected_batches) { create_list(:batch, 3, consumable_type: create(:consumable_type)) }
      let(:other_batches) { create_list(:batch, 3) }

      context 'when set' do

        let(:consumable_type_id) { expected_batches.first.consumable_type_id }

        it 'returns only batches with that consumable_type_id' do
          expect(batches_index.batches).to match_array expected_batches
        end

      end

      context 'when not set' do

        let(:consumable_type_id) { nil }

        it 'returns batches with any consumable_type_id' do
          expect(batches_index.batches).to match_array [expected_batches, other_batches].flatten
        end
      end
    end

    context 'created_after' do
      let(:created_before) { nil }
      let(:consumable_type_id) { nil }
      let(:expected_batches) { create_list(:batch, 3, created_at: DateTime.parse('2019-02-01')) }
      let(:other_batches) { create_list(:batch, 3, created_at: DateTime.parse('2018-12-01')) }

      context 'when set' do
        it 'returns batches created after the date given' do
          expect(batches_index.batches).to match_array expected_batches
        end
      end

      context 'when not set' do
        let(:created_after) { nil }

        it 'returns batches created at any date' do
          expect(batches_index.batches).to match_array [expected_batches, other_batches].flatten
        end
      end
    end

    context 'created_before' do
      let(:created_after) { nil }
      let(:consumable_type_id) { nil }
      let(:expected_batches) { create_list(:batch, 3, created_at: DateTime.parse('2019-02-01')) }
      let(:other_batches) { create_list(:batch, 3, created_at: DateTime.parse('2019-12-01')) }

      context 'when set' do
        it 'returns batches created before the date given' do
          expect(batches_index.batches).to match_array expected_batches
        end
      end

      context 'when not set' do
        let(:created_before) { nil }

        it 'returns batches created at any date' do
          expect(batches_index.batches).to match_array [expected_batches, other_batches].flatten
        end
      end
    end

  end

end
