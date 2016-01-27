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

    context "supplier does not exist" do
      it "should return a 404 with an error message" do
        get api_v1_supplier_path(:id => 123)
        expect(response.status).to be(404)
        supplier_response = JSON.parse(response.body, symbolize_names: true)

        expect(lot_response[:message]).to eq('Couldn\'t find Supplier with \'id\'=123')
      end
    end

  end
end