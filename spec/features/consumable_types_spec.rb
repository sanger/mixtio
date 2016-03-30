require "rails_helper"

RSpec.describe "ConsumableTypes", type: :feature do

  let! (:consumable_type) { build(:consumable_type) }
  let! (:consumable_types) { create_list(:consumable_type, 3) }
  let! (:saved_consumable_type) { create(:consumable_type) }

  before(:each) do
    sign_in
  end

  describe '#new' do
    let(:create_a_consumable_type) do
      visit consumable_types_path
      click_link "New Consumable Type"

      fill_in "Name*", with: consumable_type.name
      fill_in "Days to Keep*", with: consumable_type.days_to_keep
      select consumable_type.storage_condition, from: "Storage condition"

      click_button "Create Consumable type"
    end

    it "Allows a user to create a new consumable type" do
      expect { create_a_consumable_type }.to change(ConsumableType, :count).by(1)
      expect(page).to have_content("Consumable type successfully created")
    end

    it "Creates a new audit record", js: true do
      expect { create_a_consumable_type }.to change(Audit, :count).by(1)
    end

    it "Reports an error if a user adds a consumable type with invalid attributes" do

      consumable_type = create(:consumable_type)

      visit new_consumable_type_path
      expect {
        fill_in "Name", with: consumable_type.name
        click_button "Create Consumable type"
      }.to_not change(ConsumableType, :count)
      expect(page).to have_content("error prohibited this record from being saved")
    end
  end

  describe '#edit' do

    let(:edit_a_consumable_type) do
      visit edit_consumable_type_path(saved_consumable_type)
      fill_in "Name*", with: consumable_type.name
      fill_in "Days to Keep*", with: 9
      select "RT", from: "Storage condition"
      click_button "Update Consumable type"
    end

    it "Allows a user to edit an existing consumable type", js: true do
      expect { edit_a_consumable_type }.to change{ saved_consumable_type.reload.name }.to(consumable_type.name)
      expect(saved_consumable_type.days_to_keep).to eq(9)
      expect(saved_consumable_type.storage_condition).to eq("RT")
      expect(page).to have_content("Consumable type successfully updated")
    end

    it "Creates a new Audit record" do
      expect { edit_a_consumable_type }.to change(Audit, :count).by(1)
    end
  end

end