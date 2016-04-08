require 'rails_helper'

describe Api::V2::ConsumablesController, type: :request do

  describe "GET #show" do

    it "should return a serialized consumable by barcode" do
      consumable = create(:consumable)
      get api_v2_consumable_path(consumable.id)
      expect(response).to be_success
      consumable_response = JSON.parse(response.body, symbolize_names: true)

      expect(consumable_response[:data][:id]).to eql(consumable.id.to_s)
      expect(consumable_response[:data][:attributes][:depleted]).to eql(consumable.depleted)
      expect(consumable_response[:data][:attributes][:volume]).to eq(consumable.volume.to_s)
      expect(consumable_response[:data][:attributes][:unit]).to eql(consumable.unit)
      expect(consumable_response[:data][:attributes][:created_at]).to eql(consumable.created_at.strftime('%Y-%m-%dT%H:%M:%S.%LZ'))

      expect(consumable_response[:data][:relationships][:batch][:data][:id]).to eql(consumable.batch.id.to_s)
      expect(consumable_response[:data][:relationships][:consumable_type][:data][:id]).to eql(consumable.batch.consumable_type.id.to_s)

      consumable_type = consumable_response[:included].select { |obj| obj[:type] == 'consumable_types' }[0]
      expect(consumable_type[:id]).to eql(consumable.batch.consumable_type.id.to_s)
      expect(consumable_type[:attributes][:name]).to eql(consumable.batch.consumable_type.name)
    end

    context "consumable does not exist" do
      it "should return a 404 with an error message" do
        get api_v2_consumable_path(123)
        expect(response.status).to be(404)
        consumable_response = JSON.parse(response.body, symbolize_names: true)

        expect(consumable_response[:message]).to eq('Couldn\'t find Consumable with \'id\'=123')
      end
    end

  end
end