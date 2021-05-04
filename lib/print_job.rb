class PrintJob

  include ActiveModel::Model

  attr_accessor :batch, :printer, :label_type_id

  validates :batch, presence: true

  validate :printer_label_type_matches

  def printer_label_type_matches
    printer_model    = Printer.find_by(name: printer)
    label_type_model = LabelType.find_by(id: label_type_id)

    if label_type_model.nil? or printer_model.nil?
      errors.add(:printer, 'does not exist') if printer_model.nil?
      errors.add(:label_type_id, 'does not exist') if label_type_model.nil?
      return
    end

    if !printer_model.in? label_type_model.printers
      errors.add(:printer, "does not support that label type")
    end
  end

  def execute!
    return false unless valid?

    # Find the label type's external ID for use with PMB
    pmb_template_id = LabelType.find(label_type_id).external_id

    begin
      PMB::PrintJob.execute(printer_name: printer, label_template_id: pmb_template_id, labels: labels.to_h)
      return true
    ##
    # PMB doesn't format errors in the way PMB::Client expects, so somewhere within the depths
    # of PMB::Client it throws a NoMethodError
    # Also, PMB::Client doesn't give access to the json returned from the service so we can't even
    # access what went wrong to populate errors
    # This needs to be modified when PMB has fixed its errors object
    rescue StandardError => e
      return false
    end
  end

  def labels
    Labels.new(batch)
  end

end
