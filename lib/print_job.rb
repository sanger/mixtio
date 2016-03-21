class PrintJob
  include ActiveModel::SerializerSupport

  delegate :as_json, :to_json, to: :serializer

  attr_reader :batch, :printer, :label_template_id, :errors

  def initialize(args)
    @batch             = args[:batch]
    @printer           = args[:printer]
    @label_template_id = args[:label_template_id]
    @errors            = []
  end

  def config
    Rails.configuration.print_service
  end

  def execute!
    begin
      label_type = LabelType.find_by(external_id: @label_template_id)
      printer    = Printer.find_by(name: @printer)
      @errors << 'No label type selected' if label_type.nil?
      @errors << 'No printer selected' if printer.nil?
      return false unless @errors.empty?
      @errors << 'Printer does not support that label type' unless printer.in? label_type.printers
      return false unless @errors.empty?

      @response = RestClient.post config["host"], to_json, :content_type => :json
      response_successful?
    rescue => e
      if e.http_code == 422
        @errors = JSON.parse(e.response)['errors'].values.flat_map { |i| i }
      end

      return false
    end
  end

  private

  def serializer
    PrintJobSerializer.new(self)
  end

  def response_successful?
    @response.code == 200
  end

end