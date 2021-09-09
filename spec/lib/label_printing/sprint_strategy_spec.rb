require 'rails_helper'

RSpec.describe LabelPrinting::SprintStrategy do

  let(:config) do
    {
      host: 'http://sprint.host',
      template_path: 'config/sprint_templates',
      templates: {
        1 => 'tiny.json.erb',
        2 => 'missing.json.erb'
      }
    }
  end
  let(:pmb_strategy) { LabelPrinting::SprintStrategy.new(config: config) }
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

    context 'when the template is missing' do
      it 'raises an ArgumentError' do
        printer = build(:printer, label_type: build(:label_type, id: 2))
        expect { pmb_strategy.print(printer, consumable_labels) }
          .to raise_error(ArgumentError)
      end
    end

    context 'when the request to SPrint succeeds' do
      it 'returns successfully' do
        response = instance_double(Net::HTTPSuccess, code: 200, body: JSON.dump({}))
        allow(Net::HTTP).to receive(:start).and_return(response)
        expect(pmb_strategy.print(printer, consumable_labels)).to eql(OpenStruct.new({ success?: true, payload: {} }))
      end
    end

    context 'when the request to SPrint fails' do
      it 'returns an error' do
        errors = { errors: [{ message: "bad request" }] }
        response = instance_double(Net::HTTPSuccess, code: 200, body: JSON.dump(errors))
        allow(Net::HTTP).to receive(:start).and_return(response)
        expect(pmb_strategy.print(printer, consumable_labels)).to eql(OpenStruct.new({ success?: false, errors: ["bad request"] }))
      end
    end

  end
end