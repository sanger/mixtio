require 'rails_helper'

describe Api::V2::SuppliersController, type: :request do

  describe "GET #show" do

    it "should return a serialized supplier" do
      supplier = create(:supplier)
      get api_v2_supplier_path(supplier)
      expect(response).to be_success
      supplier_response = JSON.parse(response.body, symbolize_names: true)

      expect(supplier_response[:data][:id]).to eql(supplier.id.to_s)
      expect(supplier_response[:data][:attributes][:name]).to eql(supplier.name)
    end

    context "supplier does not exist" do
      it "should return a 404 with an error message" do
        get api_v2_supplier_path(:id => 123)
        expect(response.status).to be(404)
        supplier_response = JSON.parse(response.body, symbolize_names: true)

        expect(supplier_response[:message]).to include('Couldn\'t find Supplier with \'id\'=123')
      end
    end

  end
end