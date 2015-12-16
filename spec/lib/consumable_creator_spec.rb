require "rails_helper"

Dir[File.join(Rails.root,"lib","consumable_creator","*.rb")].each { |f| require f }

RSpec.describe ConsumableCreator, type: :model do

  let(:parameters)           { YAML.load_file(File.expand_path(File.join(Rails.root,"spec","lib","data.yml"))) }
  let(:run_consumable_creator!)    { ConsumableCreator.new(parameters).run! }

  before do
    run_consumable_creator!
  end

  it "should create Consumable Types" do
    parameters["consumable_types"].each do |consumable_type|
      consumable_type = ConsumableType.find_by_name(consumable_type["name"])
      expect(consumable_type).to_not be_nil
      expect(consumable_type.days_to_keep).to be_present
    end
  end

  it "should create Suppliers" do
    parameters["suppliers"].each do |supplier|
      supplier = Supplier.find_by_name(supplier["name"])
      expect(supplier).to_not be_nil
      expect(supplier.name).to be_present
    end
  end

  it "should create Lots with Batches which have Consumables" do
    parameters["lots"].each do |lot|
      lot = Lot.find_by_name(lot["name"])
      expect(lot).to_not be_nil
      expect(lot.batches).to_not be_nil
      expect(lot.batches.all? { |batch| batch.expiry_date.present? }).to be_truthy

      lot.batches.each do |batch|
        expect(batch.consumables.all? {|c| c.barcode.present?}).to be_truthy
      end
    end
  end

end