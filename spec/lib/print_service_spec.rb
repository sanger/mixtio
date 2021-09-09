require 'rails_helper'

RSpec.describe PrintService do
  let(:print_strategy_factory) do
    instance_double(LabelPrinting::PrintStrategyFactory)
  end

  let(:print_service) { PrintService.new(print_strategy_factory: print_strategy_factory)}
  let(:printer) { build(:printer) }
  let(:print_strategy) { spy('PrintStrategy') }
  let(:sub_batch) { create(:sub_batch) }

  describe '#print' do

    it 'gets a print strategy and calls in with the right arguments' do
      batch = create(:batch)
      expect(print_strategy_factory).to receive(:get_print_strategy)
                                          .with(printer)
                                          .and_return(print_strategy)

      print_service.print(printer, batch.labels)
      expect(print_strategy).to have_received(:print).with(printer, batch.labels)
    end

  end

end
