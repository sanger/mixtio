require "rails_helper"

RSpec.describe "ConsumableTypes", type: :feature do

  it "Allows a user to create a new consumable type" do
    consumable_type = build(:consumable_type)

    visit consumable_types_path
    click_link "Add new consumable type"
    expect{
      fill_in "Name", with: consumable_type.name
      click_button "Create Consumable type"
    }.to change(ConsumableType, :count).by(1)
    expect(page).to have_content("Consumable type successfully created")
  end

  it "Reports an error if a user adds a consumable type with invalid attributes" do

    consumable_type = create(:consumable_type)

    visit new_consumable_type_path
    expect{
      fill_in "Name", with: consumable_type.name
      click_button "Create Consumable type"
    }.to_not change(ConsumableType, :count)
    expect(page).to have_content("error prohibited this record from being saved")
  end

  it "Allows a user to edit an existing consumable type" do
    consumable_type = create(:consumable_type)
    new_consumable_type = build(:consumable_type)

    visit consumable_types_path
    expect{
      find(:data_id, consumable_type.id).click_link "Edit"
      fill_in "Name", with: new_consumable_type.name
      click_button "Update Consumable type"
    }.to change{ consumable_type.reload.name }.to(new_consumable_type.name)
    expect(page).to have_content("Consumable type successfully updated")
  end

end