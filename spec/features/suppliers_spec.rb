require "rails_helper"

RSpec.describe "Suppliers", type: :feature, js: true do

  let!(:supplier) { create(:supplier) }

  before(:each) do
    sign_in
  end

  describe "#edit" do

    let(:edit_a_supplier) do
      visit edit_supplier_path(supplier)
      fill_in "Name", with: "New supplier name"
      fill_in "Product code", with: "ABC123"
      click_button "Update Supplier"
    end

    it "allows a user to edit an existing supplier" do
      expect { edit_a_supplier }.to change { supplier.reload.name }
                                        .to("New supplier name")
                                        .and change { supplier.reload.product_code }
                                        .to("ABC123")
      expect(page).to have_content("Supplier successfully updated")
    end

  end

end
