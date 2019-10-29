require 'rails_helper'

describe Api::V1::BatchesController, type: :request do

  describe "GET #show" do

    it "should return a serialized batch" do
      batch = create(:batch)
      get api_v1_batch_path(batch)
      expect(response).to be_successful

      batch_response = JSON.parse(response.body, symbolize_names: true)
      expect(batch_response[:id]).to eql(batch.id)

      expect(batch_response[:expiry_date]).to eql(batch.expiry_date.strftime("%Y-%m-%d"))
      expect(batch_response[:user][:username]).to eql(batch.user.username)
      expect(batch_response[:volume]).to eql(batch.volume.to_s)
      expect(batch_response[:unit]).to eql(batch.unit)

      consumable_type = batch_response[:consumable_type]
      expect(consumable_type[:id]).to eql(batch.consumable_type.id)

      consumables = batch_response[:consumables]
      expect(consumables.count).to eql(batch.consumables.count)

      first_consumable = consumables[0]
      expect(first_consumable[:id]).to eql(batch.consumables.first.id)
      expect(first_consumable[:barcode]).to eql(batch.consumables.first.barcode)
    end

    it 'should return the batch\'s ingredients' do
      batch = create(:batch_with_ingredients)
      get api_v1_batch_path(batch)
      expect(response).to be_successful
      batch_response = JSON.parse(response.body, symbolize_names: true)

      ingredients = batch_response[:ingredients]
      expect(ingredients.count).to eql(batch.ingredients.count)

      first_ingredient = ingredients[0]
      expect(first_ingredient[:id]).to eql(batch.ingredients.first.id)
      expect(first_ingredient[:number]).to eql(batch.ingredients.first.number)
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