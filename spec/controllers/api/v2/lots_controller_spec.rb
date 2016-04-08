require 'rails_helper'

describe Api::V2::LotsController, type: :request do

  describe "GET #show" do

    it "should return a serialized lot" do
      lot = create(:lot)
      get api_v2_lot_path(lot)
      expect(response).to be_success
      lot_response = JSON.parse(response.body, symbolize_names: true)

      expect(lot_response[:data][:id]).to eql(lot.id.to_s)
      expect(lot_response[:data][:attributes][:number]).to eql(lot.number)

      expect(lot_response[:data][:relationships][:consumable_type][:data][:id]).to eql(lot.consumable_type.id.to_s)
      expect(lot_response[:data][:relationships][:kitchen][:data][:id]).to eql(lot.kitchen.id.to_s)

      consumable_type = lot_response[:included].select { |obj| obj[:type] == 'consumable_types' }[0]
      expect(consumable_type[:id]).to eql(lot.consumable_type_id.to_s)

      kitchen = lot_response[:included].select { |obj| obj[:type] == 'kitchens' }[0]
      expect(kitchen[:id]).to eql(lot.kitchen_id.to_s)
      expect(kitchen[:attributes][:name]).to eql(lot.kitchen.name)
    end

    context "lot does not exist" do
      it "should return a 404 with an error message" do
        get api_v2_lot_path(:id => 123)
        expect(response.status).to be(404)
        lot_response = JSON.parse(response.body, symbolize_names: true)

        expect(lot_response[:message]).to include('Couldn\'t find Lot with \'id\'=123')
      end
    end

  end
end