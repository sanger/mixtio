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

  it "should give the expiry date from today" do
    consumable_type = build(:consumable_type, days_to_keep: nil)
    expect(consumable_type.expiry_date_from_today).to be_nil

    consumable_type = build(:consumable_type)
    expect(consumable_type.expiry_date_from_today).to eq((Date.today + consumable_type.days_to_keep).to_s(:uk))
  end

  it "should be able to have one ingredient" do
    consumable_type = create(:consumable_type)
    child      = create(:consumable_type)
    consumable_type.ingredients << child

    expect(consumable_type.ingredients.count).to eq(1)
  end

  it "should be able to have many ingredients" do
    consumable_type = create(:consumable_type)
    ingredients = create_list(:consumable_type, 3)

    consumable_type.ingredients = ingredients

    expect(ingredients.all? {|ingredient| consumable_type.ingredients.include?(ingredient)}).to be_truthy
  end

  it "should return the latest lots attached to a particular type" do
    consumable_type = create(:consumable_type_with_ingredients_with_lots)
    parent_consumable_type = create(:consumable_type)

    expect(parent_consumable_type.latest_ingredients).to be_empty

    expect(consumable_type.latest_ingredients.count).to eq(consumable_type.ingredients.count)
  end

  it "should be able to return a collection by name (ignoring case)" do
    expect(ConsumableType).to respond_to(:order_by_name)
  end

end
