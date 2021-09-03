class PrintService

  def initialize(params)
    @print_strategy_factory = params.fetch(:print_strategy_factory)
  end

  # Print labels for a batch's consumables
  # @param [Printer] printer the printer to print to
  # @param [Array<ConsumableLabel>] consumable_labels the labels to print
  # @return [OpenStruct] an OpenStruct with a #success? method
  def print(printer, consumable_labels)
    print_strategy = print_strategy_factory.get_print_strategy(printer)
    print_strategy.print(printer, consumable_labels)
  end

private

  attr_reader :print_strategy_factory

end
