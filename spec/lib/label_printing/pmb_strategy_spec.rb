require 'rails_helper'

RSpec.describe LabelPrinting::PmbStrategy do

  let(:config) do
    {
      host: "pmb.host",
      templates: {
        1 => 226,
        2 => 227
      }
    }
  end
  let(:pmb_strategy) { LabelPrinting::PmbStrategy.new(config: config) }
  let(:printer) { build(:printer, label_type: build(:label_type, id: 1)) }
  let(:consumables) { build_list(:consumable, 3) }
  let(:consumable_labels) do
    consumables.map do |c|
      LabelPrinting::Consumable.new(consumable: c)
    end
  end

  describe '#print' do

    context 'when there is no template for printer label_type_id' do
      it 'raises an ArgumentError' do
        printer = build(:printer, label_type: build(:label_type, id: 3))
        expect { pmb_strategy.print(printer, consumable_labels) }
          .to raise_error(ArgumentError)
      end
    end

    context 'when PMB::PrintJob succeeds' do
      it 'returns successfully' do
        payload = { body: {} }
        allow(PMB::PrintJob).to receive(:execute).and_return(payload)
        expect(pmb_strategy.print(printer, consumable_labels)).to eql(OpenStruct.new({ success?: true, payload: payload }))
      end
    end

    context 'when PMB::PrintJob fails' do
      it 'returns an error' do
        allow(PMB::PrintJob).to receive(:execute).and_raise(StandardError, "bad request")
        expect(pmb_strategy.print(printer, consumable_labels)).to eql(OpenStruct.new({ success?: false, errors: ["bad request"] }))
      end
    end

  end
end