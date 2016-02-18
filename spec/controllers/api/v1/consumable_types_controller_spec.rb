require 'rails_helper'

describe Api::V1::ConsumableTypesController, type: :request do

  describe "GET #show" do

    it "should return a serialized consumable by barcode" do
      consumable_type = create(:consumable_type_with_ingredients)

      get api_v1_consumable_type_path(consumable_type)
      expect(response).to be_success

      json = JSON.parse(response.body, symbolize_names: true)

      expect(json[:id]).to eq(consumable_type.id)
      expect(json[:name]).to eq(consumable_type.name)
      expect(json[:days_to_keep]).to eq(consumable_type.days_to_keep)
      expect(json[:recipe_ingredients].length).to eq(consumable_type.recipe_ingredients.count)
    end

    context "Consumable Type does not exist" do
      it "should return a 404 with an error message" do
        get api_v1_consumable_type_path(:id => 123)
        expect(response.status).to be(404)
        json = JSON.parse(response.body, symbolize_names: true)

        expect(json[:message]).to eq('Couldn\'t find ConsumableType with \'id\'=123')
      end
    end

  end
end