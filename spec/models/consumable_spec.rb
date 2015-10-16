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

  it "should not be valid without a valid number of children" do
    expect(build(:consumable, number_of_children: 0)).to_not be_valid
    expect(build(:consumable, number_of_children: 'asdf')).to_not be_valid
  end

  it "should generate a barcode after creation" do
    consumable = create(:consumable, name: 'My consumable')
    expect(consumable.barcode).to eq("mx-my-consumable-#{consumable.id}")
  end

  it "should generate a batch number after initialize" do
    expect(build(:consumable).batch_number).to be(1)
    create(:consumable)
    expect(build(:consumable).batch_number).to be(2)
    expect(create(:consumable, batch_number: 9).batch_number).to be(9)
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

    consumable = build(:consumable, parent_ids: parents.map(&:id))
    consumables = consumable.save_or_mix
    expect(consumables.count).to eq(1)
    expect(consumables.first.parents).to eq(parents)

    consumable = build(:consumable)
    consumables = consumable.save_or_mix
    expect(consumables.count).to eq(1)
    expect(consumables.first.parents).to be_empty

    consumable = build(:consumable, parent_ids: parents.map(&:id), number_of_children: 3)
    consumables = consumable.save_or_mix
    expect(consumables.count).to eq(3)
    expect(consumables.all? {|consumable| consumable.parents == parents }).to be_truthy
  end

  it "should have the same batch number for consumables created at the same time" do
    consumable = build(:consumable_with_children)
    consumables = consumable.save_or_mix

    expect(consumables.all? { |c| c[:batch_number] == 1 }).to be_truthy()

    consumable2 = build(:consumable_with_children)
    consumables2 = consumable2.save_or_mix

    expect(consumables2.all? { |c| c[:batch_number] == 2 }).to be_truthy()

  end

  it "should not assign number_of_children attribute when children are created" do
    consumable_with_children = build(:consumable_with_children)

    consumables = consumable_with_children.save_or_mix

    expect(consumables.all? { |c| c[:number_of_children] == 1 }).to be_truthy
  end

  it "should assign parent ids correctly" do
    consumables = create_list(:consumable, 3)
    ids = Consumable.pluck(:id)

    consumable = build(:consumable, parent_ids: ids)
    expect(consumable.parent_ids).to eq(ids)

    consumable2 = build(:consumable, parent_ids: ids.join(','))
    expect(consumable2.parent_ids).to eq(ids)
  end

end
