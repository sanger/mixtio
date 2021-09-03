module LabelPrinting
  class PrintStrategyFactory

    def initialize(params)
      # This should be the print_service.yml Rails config
      @config = params.fetch(:config)
    end

    # Returns a strategy for printing labels based on a printer's service type
    # @param [Printer] printer a printer
    # @raise [ArgumentError] if a strategy can not be found for the printer's service type
    # @return [LabelPrinting::PmbStrategy, LabelPrinting::SprintStrategy] a strategy for printing labels
    def get_print_strategy(printer)
      case printer.service
      when "sprint"
        SprintStrategy.new(config: config.fetch(:sprint))
      when "pmb"
        PmbStrategy.new(config: config.fetch(:pmb))
      else
        raise ArgumentError, "Unable to find strategy for print service: #{printer.service}"
      end
    end

  private

    attr_reader :config

  end
end