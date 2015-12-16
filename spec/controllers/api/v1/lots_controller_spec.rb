require 'rails_helper'

describe Api::V1::LotsController, type: :request do

  describe "GET #show" do

    it "should return a serialized lot" do
      lot = create(:lot)
      get api_v1_lot_path(lot)
      expect(response).to be_success
      lot_response = JSON.parse(response.body, symbolize_names: true)

      expect(lot_response[:id]).to eql(lot.id)
      expect(lot_response[:name]).to eql(lot.name)
      expect(lot_response[:consumable_type_id]).to eql(lot.consumable_type_id)
      expect(lot_response[:supplier_id]).to eql(lot.supplier_id)
    end

  end
end