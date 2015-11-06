require 'rails_helper'

describe Api::V1::ConsumablesController, type: :request do

  describe "GET #show" do

    it "should return a serialized consumable by barcode" do
      consumable = create(:consumable)
      get api_v1_consumable_path(consumable.barcode)
      expect(response).to be_success
      consumable_response = JSON.parse(response.body, symbolize_names: true)
      expect(consumable_response[:id]).to eql(consumable.id)
      expect(consumable_response[:name]).to eql(consumable.name)
      expect(consumable_response[:expiry_date]).to_not be_nil
      expect(consumable_response[:arrival_date]).to_not be_nil
      expect(consumable_response[:depleted]).to eql(consumable.depleted)
      expect(consumable_response[:lot_number]).to eql(consumable.lot_number)
      expect(consumable_response[:supplier]).to eql(consumable.supplier)
      expect(consumable_response[:batch_number]).to eql(consumable.batch_number)
    end

  end
end