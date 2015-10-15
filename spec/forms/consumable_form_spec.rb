
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

  it "should be able to update a consumable with valid attributes" do
    consumable = create(:consumable)
    consumable_form = ConsumableForm.new(consumable)

    consumable_form.submit(ActionController::Parameters.new(consumable: consumable.attributes.merge('supplier' => 'Illumina')))

    expect(consumable.reload.supplier).to eq('Illumina')
  end

end