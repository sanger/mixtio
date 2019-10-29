require 'rails_helper'

RSpec.describe Labels, type: :model do

  it 'should serialize a batch into labels' do
    batch = create(:batch, consumable_type: create(:consumable_type))
    batch.sub_batches = [create(:sub_batch, volume: 1.1, unit: "mL", quantity: 3)]
    labels = Labels.new(batch).to_h

    expect(labels).to be_kind_of(Hash)

    expect(labels[:body]).to be_kind_of(Array)
    expect(labels[:body].count).to eq(3)

    first_label = labels[:body].first
    first_consumable = batch.consumables.first

    expect(first_label[:label_1][:barcode_text]).to eql(first_consumable.barcode)
    expect(first_label[:label_1][:reagent_name]).to eql(batch.consumable_type.name)
    expect(first_label[:label_1][:batch_no]).to eql(batch.number)
    expect(first_label[:label_1][:date]).to eql("Use by:#{batch.expiry_date.to_date}")
    expect(first_label[:label_1][:barcode]).to eql(first_consumable.barcode)
    expect(first_label[:label_1][:volume]).to eq("1.1mL")
    expect(first_label[:label_1][:storage_condition]).to eql('LN2')
  end

  context 'when all barcodes are identical' do

    it 'should only generate a single label' do

      batch = create(:batch, single_barcode: true)
      consumable = batch.sub_batches.first.consumables.first

      batch.sub_batches.first.consumables.each_with_index do |con, i|
        expect(batch.sub_batches.first.consumables[i].barcode).to eq(con.barcode)
      end

      labels = Labels.new(batch).to_h

      expect(labels[:body]).to be_kind_of(Array)
      expect(labels[:body].count).to eq(1)

      first_label = labels[:body].first
      expect(first_label[:label_1][:barcode]).to eql(consumable.barcode)
      expect(first_label[:label_1][:barcode_text]).to eql(consumable.barcode)

    end

  end

end
