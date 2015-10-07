
require 'rails_helper'

RSpec.describe ConsumableForm, type: :model do

  let(:consumable_form) { ConsumableForm.new }
  let!(:consumable_type) { create(:consumable_type) }
  let(:attributes) { attributes_for(:consumable) }
  let! (:parents) { create_list(:consumable, 5) }
  let(:valid_attributes) { attributes.merge('consumable_type_id' => consumable_type.id) }

  it "should create a new Consuamble with valid attributes" do
    expect {
      consumable_form.submit(ActionController::Parameters.new(consumable: valid_attributes))
    }.to change(Consumable, :count).by(1)
  end

  it "should fail to create a Consumable with invalid attributes" do
    expect {
      consumable_form.submit(ActionController::Parameters.new(consumable: attributes))
    }.to_not change(Consumable, :count)
    expect(consumable_form).to_not be_valid
  end

  it "should create a single child from a single parent" do
    consumable_form.submit(ActionController::Parameters.new(consumable: valid_attributes.merge('parent_ids' => parents.first.id.to_s)))
    expect(parents.first.children.include?(consumable_form.consumables.first)).to be_truthy
    expect(parents.first.children.count).to eq(1)
    expect(consumable_form.consumables.first.parents).to include(parents.first)
  end

  it "should create many children from a single parent" do
    consumable_form.submit(ActionController::Parameters.new(consumable: valid_attributes.merge('parent_ids' => parents.first.id.to_s, 'number_of_children' => 3)))

    expect(consumable_form.consumables.count).to eq(3)
    expect(parents.first.children.count).to eq(3)
    expect(consumable_form.consumables.all? {|consumable| consumable.parents.include?(parents.first) }).to be_truthy
  end

  it "should create a single child from multiple parents" do
    consumable_form.submit(ActionController::Parameters.new(consumable: valid_attributes.merge('parent_ids' => parents.map(&:id).join(','))))

    expect(consumable_form.consumables.count).to eq(1)
    expect(consumable_form.consumables.first.parents).to eq(parents)
    expect(parents.all? {|parent| parent.children.include?(consumable_form.consumables.first)}).to be_truthy
  end

  it "should create many children from multiple parents" do
    consumable_form.submit(ActionController::Parameters.new(consumable: valid_attributes.merge('parent_ids' => parents.map(&:id).join(','), 'number_of_children' => 3)))

    expect(consumable_form.consumables.count).to eq(3)
    expect(consumable_form.consumables.all? {|consumable| consumable.parents == parents }).to be_truthy
    expect(parents.all? {|parent| parent.children == consumable_form.consumables }).to be_truthy
  end

  it "should be able to update a consumable with valid attributes" do
    consumable = create(:consumable)
    consumable_form = ConsumableForm.new(consumable)

    consumable_form.submit(ActionController::Parameters.new(consumable: consumable.attributes.merge('supplier' => 'Illumina')))

    expect(consumable.reload.supplier).to eq('Illumina')
  end

end