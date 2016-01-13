require "rails_helper"

RSpec.describe "ConsumableTypes", type: :feature do

  let! (:consumable_types) { create_list(:consumable_type, 3) }

  it "Allows a user to create a new consumable type with ingredients", js: true do
    consumable_type = build(:consumable_type)

    visit consumable_types_path
    click_link "New Consumable Type"

    expect{
      fill_in "Name", with: consumable_type.name
      fill_in "Days to keep", with: consumable_type.days_to_keep

      click_button "Add Ingredient"
      all("select").last.select(consumable_types.first.name)

      click_button "Add Ingredient"
      all("select").last.select(consumable_types[1].name)

      click_button "Add Ingredient"
      all("select").last.select(consumable_types[2].name)

      click_button "Create Consumable type"
    }.to change(ConsumableType, :count).by(1)

    expect(ConsumableType.find_by(name: consumable_type.name).ingredients.count).to eq(3)
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
    consumable_type = create(:consumable_type_with_ingredients)
    new_consumable_type = build(:consumable_type)

    visit edit_consumable_type_path(consumable_type)
    expect{
      fill_in "Name", with: new_consumable_type.name
      fill_in "Days to keep", with: 9
      click_button "Update Consumable type"
    }.to change{ consumable_type.reload.name }.to(new_consumable_type.name)
    expect(consumable_type.days_to_keep).to eq(9)
    expect(page).to have_content("Consumable type successfully updated")
  end

end