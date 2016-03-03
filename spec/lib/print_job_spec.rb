require 'rails_helper'
require 'ostruct'

RSpec.describe PrintJob, type: :model do

  before :each do
    @batch = create(:batch_with_consumables)
    @print_job = PrintJob.new(batch: @batch, printer: 'ABC123', label_template_id: 1)
  end

  it "should have a host from config" do
    expect(@print_job.config["host"]).to be_kind_of(String)
  end

  it "should serialize a batch into a label" do
    json = JSON.parse(@print_job.to_json, symbolize_names: true)

    expect(json[:print_job]).to be_truthy
    expect(json[:print_job][:printer_name]).to eql('ABC123')
    expect(json[:print_job][:label_template_id]).to eql(1)

    labels = json[:print_job][:labels]
    expect(labels[:body]).to be_kind_of(Array)

    first_label = labels[:body].first
    first_consumable = @batch.consumables.first
    expect(first_label[:label_1][:barcode_text]).to eql(first_consumable.barcode)
    expect(first_label[:label_1][:reagent_name]).to eql(@batch.consumable_type.name)
    expect(first_label[:label_1][:batch_no]).to eql(@batch.number)
    expect(first_label[:label_1][:date]).to eql("Created: #{@batch.created_at.to_date.to_s(:uk)}")
    expect(first_label[:label_1][:barcode]).to eql(first_consumable.barcode)
    expect(first_label[:label_1][:freezer_temperature]).to eql('LN2')
  end

  it "should serialize a batch with special symbols in freezer type" do
    batch = create(:batch_with_consumables)
    batch.consumable_type.freezer_temperature = 0
    print_job = PrintJob.new(batch: batch, printer: 'ABC123', label_template_id: 1)
    json = JSON.parse(print_job.to_json, symbolize_names: true)

    labels = json[:print_job][:labels]
    expect(labels[:body]).to be_kind_of(Array)

    first_label = labels[:body].first
    expect(first_label[:label_1][:freezer_temperature]).to eql('37C')
  end

  it "should return true when a print job executes successfully" do
    allow(RestClient).to receive(:post).and_return(OpenStruct.new(:code => 200))
    expect(@print_job.execute!).to eq(true)
  end

  it "should return false when a print job fails" do
    allow(RestClient).to receive(:post).and_throw(:an_error)
    expect(@print_job.execute!).to eq(false)
  end
end
