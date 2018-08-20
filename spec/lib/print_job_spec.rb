require 'rails_helper'
require 'ostruct'

RSpec.describe PrintJob, type: :model do

  before :each do
    @batch = create(:batch_with_consumables)
    label_type = LabelType.create(name: 'TestType', external_id: 1)
    printer = Printer.create(name: 'ABC123', label_type: label_type)

    @print_job = PrintJob.new(batch: @batch, printer: printer.name, label_template_id: label_type.external_id)
  end

  it "should return true when a print job executes successfully" do
    allow(PMB::PrintJob).to receive(:execute).and_return(true)
    expect(@print_job.execute!).to eq(true)
  end

  it "should return false when a print job fails" do
    allow(PMB::PrintJob).to receive(:execute).and_raise(JsonApiClient::Errors::ServerError.new({}))
    expect(@print_job.execute!).to eq(false)
  end

  # Keeping this test in because it needs to be re-enabled once PMB has been fixed
  xit 'should populate errors when a 422 is thrown' do
    pending 'Need PMB to be fixed'
    exception = RestClient::Exception.new(OpenStruct.new(code: 422, to_str: '{"errors":{"printer":["Printer does not exist"]}}'))
    allow(RestClient).to receive(:post).and_raise(exception)
    expect(@print_job.execute!).to eq(false)
    expect(@print_job.errors.to_a).to include("Printer does not exist")
  end

  it 'should fail if printer\'s type is not selected label type' do
    label_type = LabelType.create(name: 'Other Type', external_id: 2)
    printer = Printer.create(name: 'Other Printer', label_type: label_type)
    print_job = PrintJob.new(batch: @batch, printer: printer.name, label_template_id: @print_job.label_template_id)

    expect(print_job.execute!).to eq(false)
    expect(print_job.errors.to_a).to_not include("Printer does not exist")
    expect(print_job.errors.to_a).to_not include("Label template does not exist")
    expect(print_job.errors.to_a).to include('Printer does not support that label type')
  end

  it 'should fail if printer name is not in database' do
    print_job = PrintJob.new(batch: @batch, printer: 'Other printer', label_template_id: @print_job.label_template_id)

    expect(print_job.execute!).to eq(false)
    expect(print_job.errors.to_a).to_not include("Label template does not exist")
    expect(print_job.errors.to_a).to include("Printer does not exist")
  end

  it 'should fail if label id is not in database' do
    print_job = PrintJob.new(batch: @batch, printer: @print_job.printer, label_template_id: 11)

    expect(print_job.execute!).to eq(false)
    expect(print_job.errors.to_a).to_not include("Printer does not exist")
    expect(print_job.errors.to_a).to include("Label template does not exist")
  end

end