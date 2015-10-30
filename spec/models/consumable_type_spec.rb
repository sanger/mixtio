require 'rails_helper'

RSpec.describe ConsumableType, type: :model do

  it "should not be valid without a name" do
    expect(build(:consumable_type, name: nil)).to_not be_valid
  end

  it "should not be valid without a unique name" do
    consumable_type = create(:consumable_type)
    expect(build(:consumable_type, name: consumable_type.name)).to_not be_valid
  end

  it "should not be valid without a number greater than zero" do
    expect(build(:consumable_type, days_to_keep: 0)).to_not be_valid
    expect(build(:consumable_type, days_to_keep: 'abc')).to_not be_valid
    expect(build(:consumable_type, days_to_keep: '')).to be_valid
  end

  it "should give the expiry date from today" do
    consumable_type = build(:consumable_type, days_to_keep: nil)
    expect(consumable_type.expiry_date_from_today).to be_nil

    consumable_type = build(:consumable_type)
    expect(consumable_type.expiry_date_from_today).to eq(consumable_type.days_to_keep.days_from_today)
  end

  it "should be able to have one child" do
    consumable_type = create(:consumable_type)
    child      = create(:consumable_type)

    expect(consumable_type.add_children(child).children.count).to eq(1)
  end

  it "should be able to have many children" do
    consumable_type = create(:consumable_type)
    children = create_list(:consumable_type, 3)

    consumable_type.add_children(children)

    expect(children.all? {|child| consumable_type.children.include?(child)}).to be_truthy
    expect(children.all? {|child| child.parents.include?(consumable_type)}).to be_truthy
  end

  it "should be able to have one parent" do
    consumable_type = create(:consumable_type)
    parent     = create(:consumable_type)

    expect(consumable_type.add_parents(parent).parents.count).to eq(1)
  end

  it "should be able to have many parents" do
    consumable_type = create(:consumable_type)
    parents = create_list(:consumable_type, 3)

    consumable_type.add_parents(parents)

    expect(parents.all? {|parent| consumable_type.parents.include?(parent)}).to be_truthy
    expect(parents.all? {|parent| parent.children.include?(consumable_type)}).to be_truthy
  end

  it "should be able to have lots of ingredients" do
    consumable_type = create(:consumable_type_with_parents)
    expect(consumable_type.ingredients.count).to eq(consumable_type.parents.count)
  end

  it "should return the latest consumables attached to a particular type" do
    consumable_type = create(:consumable_type_with_parents_and_consumables)
    parent_consumable_type = create(:consumable_type)

    expect(parent_consumable_type.latest_consumables).to be_empty

    expect(consumable_type.latest_consumables.count).to eq(consumable_type.parents.count)

  end

end
