require 'rails_helper'

describe Api::V1::ConsumablesController do

  describe "GET #show" do

    it "should return a serialized consumable by barcode" do
      @consumable = create(:consumable)
      get :show, barcode: @consumable.barcode, format: :json
      consumable_response = JSON.parse(response.body, symbolize_names: true)
      expect(consumable_response[:name]).to eql(@consumable.name)
    end

    it "should return a 200" do
      expect(response.status).to eq 200
    end

  end
end