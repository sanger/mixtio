require 'rails_helper'

describe Api::V2::ConsumableTypesController, type: :request do

  describe "GET #show" do

    it "should return a serialized consumable by barcode" do
      consumable_type = create(:consumable_type)

      get api_v2_consumable_type_path(consumable_type)
      expect(response).to be_successful

      json = JSON.parse(response.body, symbolize_names: true)

      expect(json[:data][:id]).to eq(consumable_type.id.to_s)
      expect(json[:data][:attributes][:name]).to eq(consumable_type.name)
      expect(json[:data][:attributes][:days_to_keep]).to eq(consumable_type.days_to_keep)
      expect(json[:data][:attributes][:storage_condition]).to eq(consumable_type.storage_condition)
    end

    context "Consumable Type does not exist" do
      it "should return a 404 with an error message" do
        get api_v2_consumable_type_path(:id => 123)
        expect(response.status).to be(404)
        json = JSON.parse(response.body, symbolize_names: true)

        expect(json[:message]).to eq('Couldn\'t find ConsumableType with \'id\'=123')
      end
    end

  end
end