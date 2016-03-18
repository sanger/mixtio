class PrintJob
  include ActiveModel::SerializerSupport

  delegate :as_json, :to_json, to: :serializer

  attr_reader :batch, :printer, :label_template_id, :errors

  def initialize(args)
    @batch = args[:batch]
    @printer = args[:printer]
    @label_template_id = args[:label_template_id]
    @errors = []
  end

  def config
    Rails.configuration.print_service
  end

  def execute!
    begin
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