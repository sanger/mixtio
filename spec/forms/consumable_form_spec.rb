
require 'rails_helper'

RSpec.describe ConsumableForm, type: :model do

  let(:controller_params)           { { controller: "consumables", action: "create"} }
  let(:params)                      { ActionController::Parameters.new(controller_params) }
  let(:consumable_form)             { ConsumableForm.new }
  let!(:consumable_type)            { create(:consumable_type) }
  let(:consumable_params)           { attributes_for(:consumable).merge('consumable_type_id' => consumable_type.id, 'current_user' => scientist.swipe_card_id) }
  let! (:parents)                   { create_list(:consumable, 5) }
  let! (:scientist)                 { create(:scientist)}

  it "should create a new Consumable with valid attributes" do
    expect {
      consumable_form.submit(params.merge(consumable: consumable_params))
    }.to change(Consumable, :count).by(1)
  end

  it "should fail to create a Consumable with invalid attributes" do
    expect {
      consumable_form.submit(params.merge(consumable: consumable_params.except('consumable_type_id')))
    }.to_not change(Consumable, :count)
    expect(consumable_form).to_not be_valid
  end

  it "should be able to update a consumable with valid attributes" do
    consumable = create(:consumable)
    consumable_form = ConsumableForm.new(consumable)

    consumable_form.submit(params.merge(consumable: consumable_params.merge('supplier' => 'Illumina')))

    expect(consumable.reload.supplier).to eq('Illumina')
  end

end