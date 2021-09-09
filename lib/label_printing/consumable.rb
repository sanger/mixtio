module LabelPrinting
  # A class to encapsulate the field values for a label
  class Consumable

    def initialize(params)
      @consumable = params.fetch(:consumable)
    end

    def barcode
      consumable.barcode
    end

    def consumable_type_name
      consumable.batch.consumable_type.name
    end

    def batch_number
      consumable.batch.number
    end

    def expiry_date
      "Use by:#{consumable.batch.expiry_date}"
    end

    def volume
      consumable.display_volume
    end

    def storage_condition
      consumable.batch.consumable_type.storage_condition
    end

    def concentration
      consumable.batch.display_concentration
    end

  private

    attr_reader :consumable
  end
end