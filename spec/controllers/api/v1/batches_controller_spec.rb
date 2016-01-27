require 'rails_helper'

describe Api::V1::BatchesController, type: :request do

  describe "GET #show" do

    it "should return a serialized batch" do
      batch = create(:batch)
      get api_v1_batch_path(batch)
      expect(response).to be_success
      batch_response = JSON.parse(response.body, symbolize_names: true)

      expect(batch_response[:id]).to eql(batch.id)
      expect(batch_response[:lot_id]).to eql(batch.lot_id)
      expect(batch_response[:expiry_date]).to eql(batch.expiry_date.to_s)
      expect(batch_response[:arrival_date]).to eql(batch.arrival_date.to_s)
    end

    context "batch does not exist" do
      it "should return a 404 with an error message" do
        get api_v1_batch_path(:id => 123)
        expect(response.status).to be(404)
        batch_response = JSON.parse(response.body, symbolize_names: true)

        expect(batch_response[:message]).to eq('Couldn\'t find Batch with \'id\'=123')
      end
    end

  end
end