require 'rails_helper'

describe Api::V1::ConsumablesController, type: :request do

  describe "GET #show" do

    it "should return a serialized consumable by barcode" do
      consumable = create(:consumable)
      get api_v1_consumable_path(consumable.barcode)
      expect(response).to be_success
      consumable_response = JSON.parse(response.body, symbolize_names: true)

      expect(consumable_response[:id]).to eql(consumable.id)
      expect(consumable_response[:depleted]).to eql(consumable.depleted)

      batch = consumable_response[:batch]
      expect(batch[:id]).to eql(consumable.batch.id)
      expect(batch[:uri]).to include(api_v1_batch_path consumable.batch)

      lot = consumable_response[:lot]
      expect(lot[:id]).to eql(consumable.batch.lot.id)
      expect(lot[:name]).to eql(consumable.batch.lot.name)
      expect(lot[:uri]).to include(api_v1_lot_path consumable.batch.lot)

      consumable_type = consumable_response[:consumable_type]
      expect(consumable_type[:id]).to eql(consumable.batch.lot.consumable_type.id)
      expect(consumable_type[:name]).to eql(consumable.batch.lot.consumable_type.name)
      expect(consumable_type[:uri]).to include(api_v1_consumable_type_path consumable.batch.lot.consumable_type)
    end

    context "consumable does not exist" do
      it "should return a 404 with an error message" do
        get api_v1_consumable_path(:barcode => 123)
        expect(response.status).to be(404)
        consumable_response = JSON.parse(response.body, symbolize_names: true)

        expect(consumable_response[:message]).to eq('Couldn\'t find Consumable')
      end
    end

  end
end