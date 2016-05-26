require 'rails_helper'

RSpec.describe Labels, type: :model do

  before(:each) { @batch = create(:batch_with_consumables) }

  it 'should serialize a batch into labels' do
    labels = Labels.new(@batch).to_h

    expect(labels).to be_kind_of(Hash)

    expect(labels[:body]).to be_kind_of(Array)
    expect(labels[:body].count).to eq(3)

    first_label = labels[:body].first
    first_consumable = @batch.consumables.first

    expect(first_label[:label_1][:barcode_text]).to eql(first_consumable.barcode)
    expect(first_label[:label_1][:reagent_name]).to eql(@batch.consumable_type.name)
    expect(first_label[:label_1][:batch_no]).to eql(@batch.number)
    expect(first_label[:label_1][:date]).to eql("Use by:#{@batch.expiry_date.to_date}")
    expect(first_label[:label_1][:barcode]).to eql(first_consumable.barcode)
    expect(first_label[:label_1][:volume]).to eq("1.1mL")
    expect(first_label[:label_1][:storage_condition]).to eql('LN2')
  end

  context 'when all barcodes are identical' do

    it 'should only generate a single label' do

      batch = create(:batch)
      consumable = create(:consumable)
      batch.consumables << (1..3).map {|n| consumable.dup}

      expect(batch.consumables[0].barcode).to eq(consumable.barcode)
      expect(batch.consumables[1].barcode).to eq(consumable.barcode)
      expect(batch.consumables[2].barcode).to eq(consumable.barcode)

      labels = Labels.new(batch).to_h

      expect(labels[:body]).to be_kind_of(Array)
      expect(labels[:body].count).to eq(1)

      first_label = labels[:body].first
      expect(first_label[:label_1][:barcode]).to eql(consumable.barcode)
      expect(first_label[:label_1][:barcode_text]).to eql(consumable.barcode)

    end

  end

end