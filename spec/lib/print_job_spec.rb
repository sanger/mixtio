require 'rails_helper'
require 'ostruct'

RSpec.describe PrintJob, type: :model do

  before :each do
    @batch = create(:batch_with_consumables)
    label_type = LabelType.create(name: 'TestType', external_id: 1)
    printer = Printer.create(name: 'ABC123', label_type: label_type)

    @print_job = PrintJob.new(batch: @batch, printer: printer.name, label_template_id: label_type.external_id)
  end

  it "should have a host from config" do
    expect(@print_job.config["host"]).to be_kind_of(String)
  end

  it "should serialize a batch into a label" do
    json = JSON.parse(@print_job.to_json, symbolize_names: true)

    expect(json[:data]).to be_truthy
    expect(json[:data][:attributes][:printer_name]).to eql('ABC123')
    expect(json[:data][:attributes][:label_template_id]).to eql(1)

    labels = json[:data][:attributes][:labels]
    expect(labels[:body]).to be_kind_of(Array)

    first_label = labels[:body].first
    first_consumable = @batch.consumables.first
    expect(first_label[:label_1][:barcode_text]).to eql(first_consumable.barcode)
    expect(first_label[:label_1][:reagent_name]).to eql(@batch.consumable_type.name)
    expect(first_label[:label_1][:batch_no]).to eql(@batch.number)
    expect(first_label[:label_1][:date]).to eql("Use by: #{@batch.expiry_date.to_date.to_s(:uk)}")
    expect(first_label[:label_1][:barcode]).to eql(first_consumable.barcode)
    expect(first_label[:label_1][:volume]).to be_nil
    expect(first_label[:label_1][:storage_condition]).to eql('LN2')
  end

  it "should serialize a volume if given one" do
    batch = create(:batch_with_consumables)
    batch.consumables.first.volume = 100
    batch.consumables.first.unit = 'μL'
    print_job = PrintJob.new(batch: batch, printer: 'ABC123', label_template_id: 1)
    json = JSON.parse(print_job.to_json, symbolize_names: true)
    labels = json[:data][:attributes][:labels]
    expect(labels[:body]).to be_kind_of(Array)

    first_label = labels[:body].first
    expect(first_label[:label_1][:volume]).to eql("100uL")
  end

  it "should serialize a batch with special symbols in storage condition" do
    batch = create(:batch_with_consumables)
    batch.consumable_type.storage_condition = 0
    print_job = PrintJob.new(batch: batch, printer: 'ABC123', label_template_id: 1)
    json = JSON.parse(print_job.to_json, symbolize_names: true)

    labels = json[:data][:attributes][:labels]
    expect(labels[:body]).to be_kind_of(Array)

    first_label = labels[:body].first
    expect(first_label[:label_1][:storage_condition]).to eql('37C')
  end

  it "should serialize a batch with special symbols in storage condition" do
    batch = create(:batch_with_consumables)
    batch.consumable_type.storage_condition = 0
    print_job = PrintJob.new(batch: batch, printer: 'ABC123', label_template_id: 1)
    json = JSON.parse(print_job.to_json, symbolize_names: true)

    labels = json[:data][:attributes][:labels]
    expect(labels[:body]).to be_kind_of(Array)

    first_label = labels[:body].first
    expect(first_label[:label_1][:storage_condition]).to eql('37C')
  end

  it "should return true when a print job executes successfully" do
    allow(RestClient).to receive(:post).and_return(OpenStruct.new(:code => 200))
    expect(@print_job.execute!).to eq(true)
  end

  it "should return false when a print job fails" do
    exception = RestClient::Exception.new(OpenStruct.new(code: 500))
    allow(RestClient).to receive(:post).and_raise(exception)
    expect(@print_job.execute!).to eq(false)
  end

  it 'should populate errors when a 422 is thrown' do
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