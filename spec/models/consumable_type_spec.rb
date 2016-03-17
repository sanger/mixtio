require 'rails_helper'

RSpec.describe ConsumableType, type: :model do

  it "should not be valid without a name" do
    expect(build(:consumable_type, name: nil)).to_not be_valid
  end

  it "should not be valid without a unique name" do
    consumable_type = create(:consumable_type)
    expect(build(:consumable_type, name: consumable_type.name)).to_not be_valid
  end

  it "should not be valid without a days_to_keep greater than zero" do
    expect(build(:consumable_type, days_to_keep: 0)).to_not be_valid
    expect(build(:consumable_type, days_to_keep: 'abc')).to_not be_valid
    expect(build(:consumable_type, days_to_keep: '')).to be_valid
  end

  it "should be able to have one recipe ingredient" do
    consumable_type = create(:consumable_type)
    child      = create(:consumable_type)
    consumable_type.recipe_ingredients << child

    expect(consumable_type.recipe_ingredients.count).to eq(1)
  end

  it "should be able to have many recipe ingredients" do
    consumable_type = create(:consumable_type)
    recipe_ingredients = create_list(:consumable_type, 3)

    consumable_type.recipe_ingredients = recipe_ingredients

    expect(recipe_ingredients.all? {|ingredient| consumable_type.recipe_ingredients.include?(ingredient)}).to be_truthy
  end

  it "should return the latest ingredient for each item in its recipe" do
    consumable_type = create(:consumable_type_with_ingredients)
    parent_consumable_type = create(:consumable_type)

    expect(parent_consumable_type.latest_ingredients).to be_empty
    expect(consumable_type.latest_ingredients.count).to eq(consumable_type.recipe_ingredients.count)
  end

  it "should be able to return a collection by name (ignoring case)" do
    expect(ConsumableType).to respond_to(:order_by_name)
  end

  it "should be auditable" do
    expect(build(:consumable_type)).to respond_to(:audits)
  end

  it "should simplify storage condition" do
    expect(build(:consumable_type, storage_condition: 0).simple_storage_condition).to eql('37C')
  end

end
