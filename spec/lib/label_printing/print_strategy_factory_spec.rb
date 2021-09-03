require 'rails_helper'

RSpec.describe 'LabelPrinting::PrintStrategyFactory' do
  let(:print_config) do
    {
      pmb: {
        host: "pmb.host"
      },
      sprint: {
        host: "sprint.host"
      },
    }
  end

  let(:print_strategy_factory) do
    LabelPrinting::PrintStrategyFactory.new(config: print_config)
  end

  describe '#get_print_strategy' do

    context 'when printer service is pmb' do
      let(:printer) { FactoryBot.build(:printer, service: 'pmb') }

      it 'returns PmbStrategy' do
        expect(print_strategy_factory.get_print_strategy(printer)).to be_instance_of(LabelPrinting::PmbStrategy)
      end
    end

    context 'when printer service is sprint' do
      let(:printer) { FactoryBot.build(:printer, service: 'sprint' )}

      it 'returns SprintStrategy' do
        expect(print_strategy_factory.get_print_strategy(printer)).to be_instance_of(LabelPrinting::SprintStrategy)
      end
    end

    context 'when printer service is unknown' do
      let(:printer) { FactoryBot.build(:printer, service: 'foobar') }

      it 'raises an ArgumentError' do
        expect { print_strategy_factory.get_print_strategy(printer) }.to raise_error(ArgumentError)
      end
    end

  end
end