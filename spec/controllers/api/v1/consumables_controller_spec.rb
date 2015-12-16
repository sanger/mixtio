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
      expect(consumable_response[:depleted]).to eql(consumable.depleted)

      batch = consumable_response[:batch]
      expect(batch[:id]).to eql(consumable.batch.id)
      expect(batch[:lot_id]).to eql(consumable.batch.lot_id)
      expect(batch[:expiry_date]).to eql(consumable.batch.expiry_date.to_s)
      expect(batch[:arrival_date]).to eql(consumable.batch.arrival_date.to_s)

      lot = consumable_response[:lot]
      expect(lot[:id]).to eql(consumable.batch.lot.id)
      expect(lot[:name]).to eql(consumable.batch.lot.name)

      consumable_type = consumable_response[:consumable_type]
      expect(consumable_type[:id]).to eql(consumable.batch.lot.consumable_type.id)
      expect(consumable_type[:name]).to eql(consumable.batch.lot.consumable_type.name)
    end

  end
end