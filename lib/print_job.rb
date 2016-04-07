class PrintJob

  include ActiveModel::Model

  attr_accessor :batch, :printer, :label_template_id

  validates :batch, presence: true

  validate :printer_label_type_matches

  def printer_label_type_matches
    printer_model    = Printer.find_by(name: printer)
    label_type_model = LabelType.find_by(external_id: label_template_id)
    if label_type_model.nil? or printer_model.nil?
      errors.add(:printer, 'does not exist') if printer_model.nil?
      errors.add(:label_template_id, 'does not exist') if label_type_model.nil?
      return
    end

    if !printer_model.in? label_type_model.printers
      errors.add(:printer, "does not support that label type")
    end
  end

  def config
    Rails.configuration.print_service
  end

  def execute!
    begin
      if valid?
        @response = RestClient.post config["host"], to_json, content_type: "application/vnd.api+json"
        response_successful?
      else
        return false
      end
    rescue RestClient::Exception => e
      if e.http_code == 422
        JSON.parse(e.response)['errors'].each do |type, err_array|
          err_array.each do |error|
            # Remove the type from the start of the error if it's there.
            errors.add(type, error.sub(/^#{type} /i, ''))
          end
        end
      end
      return false
    end
  end

  def to_json
    {
        data: {
            attributes: serializer.attributes
        }
    }.to_json
  end

  private

  def serializer
    PrintJobSerializer.new(self)
  end

  def response_successful?
    @response.code == 200
  end

end