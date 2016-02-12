require 'rails_helper'

describe Api::V1::BatchesController, type: :request do

  describe "GET #show" do

    it "should return a serialized batch" do
      batch = create(:batch)
      get api_v1_batch_path(batch)
      expect(response).to be_success
      batch_response = JSON.parse(response.body, symbolize_names: true)

      expect(batch_response[:id]).to eql(batch.id)

      consumable_type = batch_response[:consumable_type]

      expect(consumable_type[:id]).to eql(batch.consumable_type.id)
      expect(consumable_type[:uri]).to include(api_v1_consumable_type_path batch.consumable_type)

      expect(batch_response[:expiry_date]).to eql(batch.expiry_date.to_s)
    end

    context "batch does not exist" do
      it "should return a 404 with an error message" do
        get api_v1_batch_path(:id => 123)
        expect(response.status).to be(404)
        batch_response = JSON.parse(response.body, symbolize_names: true)

        expect(batch_response[:message]).to include('Couldn\'t find Batch with \'id\'=123')
      end
    end

  end
end