require 'rails_helper'

describe Api::V2::BatchesController, type: :request do

  describe "GET #show" do

    it "should return a serialized batch" do
      batch = create(:batch)
      get api_v2_batch_path(batch)
      expect(response).to be_successful

      batch_response = JSON.parse(response.body, symbolize_names: true)
      expect(batch_response[:data][:id]).to eql(batch.id.to_s)

      expect(batch_response[:data][:attributes][:expiry_date]).to eql(batch.expiry_date.strftime("%Y-%m-%d"))
      expect(batch_response[:data][:attributes][:volume]).to eql(batch.volume.to_s)
      expect(batch_response[:data][:attributes][:unit]).to eql(batch.unit)

      expect(batch_response[:data][:relationships][:user][:data][:id]).to eql(batch.user.id.to_s)
      expect(batch_response[:data][:relationships][:kitchen][:data][:id]).to eql(batch.kitchen.id.to_s)
      expect(batch_response[:data][:relationships][:consumable_type][:data][:id]).to eql(batch.consumable_type.id.to_s)

      consumable_type = batch_response[:included].select { |obj| obj[:type] == 'consumable_types' }[0]
      expect(consumable_type[:id]).to eql(batch.consumable_type.id.to_s)
      expect(consumable_type[:attributes][:name]).to eql(batch.consumable_type.name)

      consumables = batch_response[:data][:relationships][:consumables][:data]
      expect(consumables.count).to eql(batch.consumables.count)

      first_consumable = consumables[0]
      expect(first_consumable[:id]).to eql(batch.consumables.first.id.to_s)
    end

    it 'should return the batch\'s ingredients' do
      batch = create(:batch_with_ingredients)
      get api_v2_batch_path(batch)
      expect(response).to be_successful
      batch_response = JSON.parse(response.body, symbolize_names: true)

      ingredients = batch_response[:data][:relationships][:ingredients][:data]
      expect(ingredients.count).to eql(batch.ingredients.count)

      first_ingredient = ingredients[0]
      expect(first_ingredient[:id]).to eql(batch.ingredients.first.id.to_s)
    end

    context "batch does not exist" do
      it "should return a 404 with an error message" do
        get api_v2_batch_path(:id => 123)
        expect(response.status).to be(404)
        batch_response = JSON.parse(response.body, symbolize_names: true)

        expect(batch_response[:message]).to include('Couldn\'t find Batch with \'id\'=123')
      end
    end

  end
end