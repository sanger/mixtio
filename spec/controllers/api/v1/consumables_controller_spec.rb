require 'rails_helper'

describe Api::V1::ConsumablesController, type: :request do

  describe "GET #show" do

    it "should return a serialized consumable by barcode" do
      batch = create(:batch_with_consumables)
      consumable = batch.consumables.first
      get api_v1_consumable_path(consumable.id)
      expect(response).to be_successful
      consumable_response = JSON.parse(response.body, symbolize_names: true)

      expect(consumable_response[:id]).to eql(consumable.id)
      expect(consumable_response[:depleted]).to eql(consumable.depleted)
      expect(consumable_response[:volume]).to eq(consumable.volume.to_s)
      expect(consumable_response[:unit]).to eql(consumable.unit)
      expect(consumable_response[:created_at]).to eql(consumable.created_at.strftime('%Y-%m-%dT%H:%M:%S.%LZ'))

      batch = consumable_response[:batch]
      expect(batch[:id]).to eql(consumable.batch.id)

      consumable_type = consumable_response[:consumable_type]
      expect(consumable_type[:id]).to eql(consumable.batch.consumable_type.id)
      expect(consumable_type[:name]).to eql(consumable.batch.consumable_type.name)
    end

    context "consumable does not exist" do
      it "should return a 404 with an error message" do
        get api_v1_consumable_path(123)
        expect(response.status).to be(404)
        consumable_response = JSON.parse(response.body, symbolize_names: true)

        expect(consumable_response[:message]).to eq('Couldn\'t find Consumable with \'id\'=123')
      end
    end

    context "when receiving a request from CGAP LIMS" do
      before(:all) do
        batch = create(:batch_with_consumables)
        @consumable = batch.consumables.first
        get "/api/v1/consumables?barcode=#{@consumable.barcode}"
        @consumable_response = JSON.parse(response.body, symbolize_names: true)
      end

      it "should be successful" do
        expect(response).to be_successful
      end

      it "should return a serialized consumable" do
        expect(@consumable_response[:consumables][0][:id]).to eql(@consumable.id)
        expect(@consumable_response[:consumables][0][:depleted]).to eql(@consumable.depleted)
        expect(@consumable_response[:consumables][0][:volume]).to eq(@consumable.volume)
        expect(@consumable_response[:consumables][0][:unit]).to eql(@consumable.unit)
        expect(@consumable_response[:consumables][0][:sub_batch_id]).to eql(@consumable.sub_batch_id)
        expect(@consumable_response[:consumables][0][:created_at]).to eql(@consumable.created_at.strftime('%Y-%m-%dT%H:%M:%S.%LZ'))
      end

      it "should also return the corresponding batch" do
        batch = @consumable_response[:consumables][0][:batch]
        expect(batch[:id]).to eql(@consumable.batch.id)
      end

      it "should also return the corresponding consumable type" do
        consumable_type = @consumable_response[:consumables][0][:consumable_type]
        expect(consumable_type[:id]).to eql(@consumable.batch.consumable_type.id)
        expect(consumable_type[:name]).to eql(@consumable.batch.consumable_type.name)
      end
    end

  end
end
