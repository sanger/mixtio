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

      consumable_type = lot_response[:consumable_type]
      expect(consumable_type[:id]).to eql(lot.consumable_type_id)
      expect(consumable_type[:uri]).to include(api_v1_consumable_type_path lot.consumable_type)

      supplier = lot_response[:supplier]
      expect(supplier[:id]).to eql(lot.supplier_id)
      expect(supplier[:uri]).to include(api_v1_supplier_path lot.supplier)
    end

    context "lot does not exist" do
      it "should return a 404 with an error message" do
        get api_v1_lot_path(:id => 123)
        expect(response.status).to be(404)
        lot_response = JSON.parse(response.body, symbolize_names: true)

        expect(lot_response[:message]).to eq('Couldn\'t find Lot with \'id\'=123')
      end
    end

  end
end