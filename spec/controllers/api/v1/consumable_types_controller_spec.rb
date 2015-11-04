require 'rails_helper'

describe Api::V1::ConsumableTypesController, type: :request do

  describe "GET #show" do

    it "should return a serialized consumable by barcode" do
      consumable_type = create(:consumable_type_with_parents_and_consumables)

      get api_v1_consumable_type_path(consumable_type)
      expect(response).to be_success

      json = JSON.parse(response.body, symbolize_names: true)

      expect(json[:id]).to eq(consumable_type.id)
      expect(json[:name]).to eq(consumable_type.name)
      expect(json[:days_to_keep]).to eq(consumable_type.days_to_keep)
      expect(json[:expiry_date_from_today]).to eq(consumable_type.expiry_date_from_today)
      expect(json[:latest_consumables].length).to eq(consumable_type.latest_consumables.count)
    end

  end
end