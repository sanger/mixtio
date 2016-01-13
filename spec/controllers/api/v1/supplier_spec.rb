require 'rails_helper'

describe Api::V1::SuppliersController, type: :request do

  describe "GET #show" do

    it "should return a serialized supplier" do
      supplier = create(:supplier)
      get api_v1_supplier_path(supplier)
      expect(response).to be_success
      supplier_response = JSON.parse(response.body, symbolize_names: true)

      expect(supplier_response[:id]).to eql(supplier.id)
      expect(supplier_response[:name]).to eql(supplier.name)
    end

  end
end