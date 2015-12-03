require "rails_helper"

Dir[File.join(Rails.root,"lib","consumable_creator","*.rb")].each { |f| require f }

RSpec.describe ConsumableCreator, type: :model do

  let(:consumables)           { YAML.load_file(File.expand_path(File.join(Rails.root,"spec","lib","data.yml"))) }
  let(:consumable_creator)    { ConsumableCreator.new(consumables) }

  it "should create a consumable type for each key" do
    consumable_creator.run!
    consumables.each do |k, v|
      consumable_type = ConsumableType.find_by_name(v["name"])
      expect(consumable_type).to_not be_nil
      expect(consumable_type.days_to_keep).to be_present
    end
  end

  it "should create a consumable type for each ingredient" do
    consumable_creator.run!
    consumables.each do |k, v|
      consumable_type = ConsumableType.find_by_name(v["name"])
      expect(consumable_type.ingredients).to_not be_nil
      expect(consumable_type.ingredients.count).to eq(v["ingredients"].length)
    end
  end

  it "should create a bunch of consumables" do
    consumable_creator.run!
    consumables.each do |k, v|
      consumable_type = ConsumableType.find_by_name(v["name"])
      consumable_type.ingredients.each do |ingredient|
        expect(ingredient.consumables.count).to eq(3)
        expect(ingredient.consumables.latest.created_at.to_date).to eq(Date.today)
      end
    end
  end

end