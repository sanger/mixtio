module LabelPrinting
  # Handles printing labels via PrintMyBarcode
  class PmbStrategy

    def initialize(params)
      @config = params.fetch(:config)
    end

    def print(printer, consumable_labels)
      pmb_template_id = config[:templates][printer.label_type_id]

      if pmb_template_id.nil?
        raise ArgumentError, "PMB template not found for label type id #{printer.label_type_id}"
      end

      labels = create_labels(consumable_labels)

      begin
        result = PMB::PrintJob.execute(printer_name: printer.name, label_template_id: pmb_template_id, labels: labels)
        return OpenStruct.new({ success?: true, payload: result })
        ##
        # PMB doesn't format errors in the way PMB::Client expects, so somewhere within the depths
        # of PMB::Client it throws a NoMethodError
        # Also, PMB::Client doesn't give access to the json returned from the service so we can't even
        # access what went wrong to populate errors
        # This needs to be modified when PMB has fixed its errors object
      rescue StandardError => e
        Rails.logger.error(e.message)
        return OpenStruct.new({ success?: false, errors: [e.message] })
      end
    end

  private

    attr_reader :config

    def create_labels(consumable_labels)
      {
        body: consumable_labels.map do |consumable_label|
          {
            label: {
              barcode_text: consumable_label.barcode,
              reagent_name: consumable_label.consumable_type_name,
              batch_no: consumable_label.batch_number,
              date: consumable_label.expiry_date,
              barcode: consumable_label.barcode,
              volume: consumable_label.volume,
              storage_condition: consumable_label.storage_condition,
              concentration: consumable_label.concentration,
            }
          }
        end
      }
    end

  end
end