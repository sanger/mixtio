require 'rails_helper'

describe "Favourites", type: :request do

  describe '#create' do

    before :each do
      sign_in_request
    end

    it 'adds a favourite consumable type for the current user' do
      consumable_type = create(:consumable_type)
      post favourite_path(consumable_type)
      expect(consumable_type.users).to eq([test_user])
      expect(test_user.consumable_types).to eq([consumable_type])
    end

    it 'removes a favourite consumable type for the current user' do
      test_user.consumable_types = create_list(:consumable_type, 3)
      delete favourite_path(test_user.consumable_types.first)
      expect(test_user.consumable_types.reload.length).to eq(2)
    end

  end
end