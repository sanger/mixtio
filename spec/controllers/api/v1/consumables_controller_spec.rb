require 'rails_helper'

describe Api::V1::ConsumablesController, type: :request do

  describe "GET #show" do

    it "should return a serialized consumable by barcode" do
      @consumable = create(:consumable)
      get api_v1_consumable_path(@consumable.barcode)
      expect(response).to be_success
      consumable_response = JSON.parse(response.body, symbolize_names: true)
      expect(consumable_response[:name]).to eql(@consumable.name)
    end

  end
end