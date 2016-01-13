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

  end
end