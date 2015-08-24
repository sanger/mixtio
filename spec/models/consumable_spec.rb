require 'rails_helper'

RSpec.describe Consumable, type: :model do

  it "should not be valid without a name" do
    expect(build(:consumable, name: nil)).to_not be_valid
  end

  it "should not be valid without an expiry date" do
    expect(build(:consumable, expiry_date: nil)).to_not be_valid
  end

  it "should not be valid with an expiry date in the past" do
    consumable = build(:consumable, expiry_date: 1.day.ago)
    expect(consumable).to_not be_valid
    expect(consumable.errors.messages[:expiry_date]).to include(I18n.t('errors.future_date'))
  end

  it "should not be valid without a lot number" do
    expect(build(:consumable, lot_number: nil)).to_not be_valid
  end

  it "should not be valid without a consumable Type" do
    expect(build(:consumable, consumable_type: nil)).to_not be_valid
    expect(build(:consumable, consumable_type_id: nil)).to_not be_valid
  end

  it "should generate a barcode after creation" do
    consumable = create(:consumable, name: 'My consumable')
    expect(consumable.barcode).to eq("mx-my-consumable-#{consumable.id}")
  end

  it "should be able to have one child" do
    consumable = create(:consumable)
    child      = create(:consumable)

    expect(consumable.add_children(child).children.count).to eq(1)
  end

  it "should be able to have many children" do
    consumable = create(:consumable)
    children = create_list(:consumable, 3)

    consumable.add_children(children)

    expect(children.all? {|child| consumable.children.include?(child)}).to be_truthy
    expect(children.all? {|child| child.parents.include?(consumable)}).to be_truthy
  end

  it "should be able to have one parent" do
    consumable = create(:consumable)
    parent     = create(:consumable)

    expect(consumable.add_parents(parent).parents.count).to eq(1)
  end

  it "should be able to have many parents" do
    consumable = create(:consumable)
    parents = create_list(:consumable, 3)

    consumable.add_parents(parents)

    expect(parents.all? {|parent| consumable.parents.include?(parent)}).to be_truthy
    expect(parents.all? {|parent| parent.children.include?(consumable)}).to be_truthy
  end

  it "#save_or_mix" do
    parents = create_list(:consumable, 2)
    consumable = build(:consumable)

    consumables = consumable.save_or_mix(parents.map(&:id))
    expect(consumables.count).to eq(1)
    expect(consumables.first.parents).to eq(parents)

    consumables = consumable.save_or_mix('')
    expect(consumables.count).to eq(1)
    expect(consumables.first.parents).to be_empty

    consumables = consumable.save_or_mix(parents.map(&:id), 3)
    expect(consumables.count).to eq(3)
    expect(consumables.all? {|consumable| consumable.parents == parents }).to be_truthy
  end

end
