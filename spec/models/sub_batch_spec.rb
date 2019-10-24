require 'rails_helper'

RSpec.describe SubBatch, type: :model do

  describe 'validation' do

    context 'without volume' do
      it 'is invalid' do
        expect(build(:sub_batch, volume: nil)).to_not be_valid
      end
    end

    context 'when volume is not a number' do
      it 'is invalid' do
        expect(build(:sub_batch, volume: 'seven')).to_not be_valid
      end
    end

    context 'when volume is less than 0' do
      it 'is invalid' do
        expect(build(:sub_batch, quantity: -1)).to_not be_valid
      end
    end

    context 'without a unit' do
      it 'is invalid' do
        expect(build(:sub_batch, unit: nil)).to_not be_valid
      end
    end

    context 'without a quantity' do
      it 'is invalid' do
        expect(build(:sub_batch, quantity: nil)).to_not be_valid
      end
    end

    context 'when quantity is less than 1' do
      it 'is invalid' do
        expect(build(:sub_batch, quantity: -1)).to_not be_valid
      end
    end

    context 'when quantity is not an integer' do
      it 'is invalid' do
        expect(build(:sub_batch, quantity: 1.0)).to_not be_valid
      end
    end

  end

  describe 'before_save' do

    context 'when SubBatch is a new record' do

      before do
        @sub_batch = build(:sub_batch)
      end

      it 'creates consumables on save' do
        @sub_batch.save
        expect(@sub_batch.consumables.count).to eql(@sub_batch.quantity)
      end

    end

    context 'when SubBatch is not a new record' do

      before do
        @sub_batch = create(:sub_batch, volume: 5, quantity: 7)
      end

      it 'does not create consumables on save' do
        expect(@sub_batch.consumables.count).to eql(7)
        expect(@sub_batch.volume).to eql(5.0)
        @sub_batch.quantity = 4
        @sub_batch.volume = 10.0
        @sub_batch.save
        expect(@sub_batch.consumables.count).to eql(7)
        expect(@sub_batch.volume).to eql(10.0)
      end

    end

  end

  describe 'after_create' do

    context 'when barcode_type is "single"' do

      before do
        @sub_batch = build(:sub_batch, barcode_type: 'single')
        @sub_batch.save
      end

      it 'unifies the consumables\' barcodes' do
        barcodes = @sub_batch.consumables.map(&:barcode).uniq
        expect(barcodes.size).to eql(1)
      end

    end

    context 'when barcode_type is not "single"' do

      before do
        @sub_batch = build(:sub_batch, barcode_type: 'aliquots')
        @sub_batch.save
      end

      it 'leaves the consumables with individual barcodes' do
        barcodes = @sub_batch.consumables.map(&:barcode).uniq
        expect(barcodes.size).to eql(@sub_batch.quantity)
      end

    end

  end

  describe '#single_barcode?' do

    context 'when consumables all have the same barcode' do
      before do
        @sub_batch = create(:sub_batch, barcode_type: 'single')
      end

      it 'returns true' do
        expect(@sub_batch.single_barcode?).to be true
      end
    end

    context 'when consumables have different barcodes' do
      before do
        @sub_batch = create(:sub_batch, barcode_type: 'aliquots')
      end

      it 'returns false' do
        expect(@sub_batch.single_barcode?).to be false
      end
    end

  end

  describe '#size' do
    before do
      @sub_batch = create(:sub_batch, quantity: 10)
    end

    it 'returns the count of Consumables belonging to the SubBatch' do
      expect(@sub_batch.size).to eql 10
    end
  end

  describe '#total_volume' do

    before do
      @sub_batch = create(:sub_batch, quantity: 10, volume: 5.0, unit: 'mL')
    end

    context 'when with_unit is true' do

      it 'returns the total volume with its unit as a string' do
        expect(@sub_batch.total_volume(true)).to eql('50.0mL')
      end

    end

    context 'when with_unit is false' do

      it 'returns the total volume as a decimal' do
        expect(@sub_batch.total_volume(false)).to eql(50.0)
      end

    end

  end

end