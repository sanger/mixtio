require "rails_helper"

RSpec.describe "ConsumableTypes", type: :feature do

  let! (:consumable_types) { create_list(:consumable_type, 3) }

  it "Allows a user to create a new consumable type with ingredients", js: true do
    consumable_type = build(:consumable_type)

    visit consumable_types_path
    click_link "Add new consumable type"
    expect{
      fill_in "Name", with: consumable_type.name
      fill_in "Days to keep", with: consumable_type.days_to_keep

      find(:data_behavior, "ingredients").all("select").last.find("option", text: consumable_types.first.name).select_option
      find(:data_behavior, "ingredients").all("li").last.find(:data_behavior, "add-parent").click

      find(:data_behavior, "ingredients").all("select").last.find("option", text: consumable_types[1].name).select_option
      find(:data_behavior, "ingredients").all("li").last.find(:data_behavior, "add-parent").click

      find(:data_behavior, "ingredients").all("select").last.find("option", text: consumable_types.last.name).select_option

      click_button "Create Consumable type"
    }.to change(ConsumableType, :count).by(1)

    expect(ConsumableType.find_by(name: consumable_type.name).parents.count).to eq(3)
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

  it "Allows a user to edit an existing consumable type", js: true do
    consumable_type = create(:consumable_type_with_parents)
    new_consumable_type = build(:consumable_type)

    visit consumable_types_path
    expect{
      find(:data_id, consumable_type.id).click_link "Edit"
      fill_in "Name", with: new_consumable_type.name
      fill_in "Days to keep", with: 9
      find(:data_behavior, "ingredients").all("li").last.find(:data_behavior, "remove_parent").click
      click_button "Update Consumable type"
    }.to change{ consumable_type.reload.name }.to(new_consumable_type.name)
    expect(consumable_type.days_to_keep).to eq(9)
    expect(consumable_type.parents.count).to eq(2)
    expect(page).to have_content("Consumable type successfully updated")
  end

end