require "erb"
require "json"
require "net/http"
require "uri"

module LabelPrinting
  # Handles printing consumable labels using SPrint
  class SprintStrategy

    def initialize(params)
      # the sprint section of the print_service.yml config file
      @config = params.fetch(:config)
    end

    # Sends a request to SPrint to print labels for the given consumables
    # using the printer specified
    #
    # @param [Printer] printer the printer to print the labels
    # @param [Array<Consumable>] consumables list of consumables to print labels for
    # @raise [ArgumentError] if a template name is not found for the printer's label type id
    # @raise [ArgumentError] if a template file is not found for the label type
    # @return [OpenStruct] OpenStruct with a #success? attribute
    def print(printer, consumables)
      template_name = config[:templates][printer.label_type_id]

      if template_name.nil?
        raise ArgumentError, "SPrint template not found for label type id: #{printer.label_type_id}"
      end

      file_path = File.join(config[:template_path], template_name)

      begin
        sprint_template = File.read(file_path)
      rescue Errno::ENOENT => _e
        raise ArgumentError, "SPrint template file not found: #{file_path}"
      end

      uri = URI(config[:host])
      request = Net::HTTP::Post.new(uri)
      request_template = ERB.new(sprint_template)
                            .result_with_hash(
                              printer: printer.name,
                              mutation: print_mutation,
                              consumables: consumables
                            )
      request.body = request_template
      request.set_content_type("application/json")

      response = Net::HTTP.start(uri.hostname, uri.port) do |http|
        http.request(request)
      end

      case response.code.to_i
        when 200 then
          response_body = JSON.parse(response.body)
          if response_body["errors"]
            return OpenStruct.new({ success?: false, errors: [response_body["errors"][0]["message"]]})
          else
            return OpenStruct.new({ success?: true, payload: response_body })
          end
        else
          return OpenStruct.new({ success?: false, errors: ["Failed to print labels via SPrint"]})
      end

    end

  private

    attr_reader :config

    def print_mutation
      # squish removes any newline characters
      <<-MUTATION.squish
        mutation Print($printRequest: PrintRequest!, $printer: String!) {
          print(printRequest: $printRequest, printer: $printer) {
            jobId
          }
        }
      MUTATION
    end

  end
end
