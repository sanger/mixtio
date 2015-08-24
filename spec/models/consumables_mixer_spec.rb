require 'rails_helper'

RSpec.describe ConsumablesMixer, type: :model do

  let! (:parents) { create_list(:consumable, 5) }

  it "should create a single child from a single parent" do
    consumable = ConsumablesMixer.mix(parents: parents.first).first
    expect(consumable).to be_valid
    expect(consumable.name).to eq(parents.first.name)
    expect(consumable.barcode).to_not eq(parents.first.barcode)
    expect(consumable.parents.include?(parents.first)).to be_truthy
    expect(parents.first.children.include?(consumable)).to be_truthy
    expect(parents.first.children.count).to eq(1)

    child = build(:consumable)
    consumable = ConsumablesMixer.mix(parents: parents.last, consumable: child).first
    expect(consumable).to be_valid
    expect(consumable.name).to eq(child.name)
    expect(consumable.lot_number).to eq(child.lot_number)
    expect(consumable.parents.include?(parents.last)).to be_truthy
    expect(parents.last.children.include?(consumable)).to be_truthy
    expect(parents.last.children.count).to eq(1)
  end

  it "should create many children from a single parent" do
    consumables = ConsumablesMixer.mix(parents: parents.first, limit: 3)
    expect(consumables.count).to eq(3)
    expect(parents.first.children.count).to eq(3)
    expect(consumables.all? {|consumable| consumable.name == parents.first.name}).to be_truthy
  end

  it "should create a single child from multiple parents" do
    child = build(:consumable)
    consumable = ConsumablesMixer.mix(parents: parents, consumable: child).first
    expect(consumable).to be_valid
    expect(consumable.name).to eq(child.name)
    expect(consumable.lot_number).to eq(child.lot_number)
    expect(consumable.parents).to eq(parents)
    expect(parents.all? {|parent| parent.children.include?(consumable)}).to be_truthy
    expect(parents.all? {|parent| parent.children.count == 1}).to be_truthy
  end

  it "should create many children from multiple parents" do
    child = build(:consumable)
    consumables = ConsumablesMixer.mix(parents: parents, consumable: child, limit: 3)
    expect(consumables.count).to eq(3)
    expect(consumables.all? {|consumable| consumable.parents == parents }).to be_truthy
    expect(parents.all? {|parent| parent.children == consumables }).to be_truthy
    expect(consumables.first.name).to eq(child.name)
  end

end