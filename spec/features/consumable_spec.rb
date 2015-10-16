require "rails_helper"

RSpec.describe "Consumables", type: feature do

  let! (:consumable_types) { create_list(:consumable_type, 4) }
  let! (:scientist)        { create(:scientist) }

  it "Displays a list of consumables to the user" do
    consumable = create(:consumable)
    consumable_2 = create(:consumable)

    visit consumables_path

    expect(page).to have_content(consumable.name)
  end

  it "Allows a user to create a new consumable" do
    consumable = build(:consumable)

    visit consumables_path
    click_link "Add new consumable"
    expect{
      fill_in "User swipe card id/barcode", with: scientist.swipe_card_id
      fill_in "Name", with: consumable.name
      fill_in "Expiry date", with: consumable.expiry_date
      fill_in "Lot number", with: consumable.lot_number
      fill_in "Arrival date", with: consumable.arrival_date
      fill_in "Supplier", with: consumable.supplier
      select consumable_types.first.name, from: 'Consumable type'
      click_button "Create Consumable"
    }.to change(Consumable, :count).by(1)
    expect(page).to have_content("Consumable successfully created")
  end

  it "Allows a user to create multiple new consumables" do
    consumable = build(:consumable)

    visit consumables_path
    click_link "Add new consumable"
    expect{
      fill_in "User swipe card id/barcode", with: scientist.swipe_card_id
      fill_in "Name", with: consumable.name
      fill_in "Expiry date", with: consumable.expiry_date
      fill_in "Lot number", with: consumable.lot_number
      fill_in "Arrival date", with: consumable.arrival_date
      fill_in "Supplier", with: consumable.supplier
      fill_in "Number of children", with: 3
      select consumable_types.first.name, from: 'Consumable type'
      click_button "Create Consumable"
    }.to change(Consumable, :count).by(3)
    expect(page).to have_content("Consumable successfully created")
  end

  it "Reports an error if a user adds a consumable with invalid attributes" do

    consumable = build(:consumable, name: nil)

    visit new_consumable_path
    expect{
      fill_in "User swipe card id/barcode", with: scientist.swipe_card_id
      fill_in "Name", with: consumable.name
      fill_in "Expiry date", with: consumable.expiry_date
      fill_in "Lot number", with: consumable.lot_number
      fill_in "Arrival date", with: consumable.arrival_date
      fill_in "Supplier", with: consumable.supplier
      select consumable_types.first.name, from: 'Consumable type'
      click_button "Create Consumable"
    }.to_not change(Consumable, :count)

    expect(page).to have_content("error prohibited this record from being saved")
  end

  it "Allows a user to edit a consumable" do
    consumable = create(:consumable)
    new_consumable = build(:consumable)

    visit consumables_path
    expect{
      find(:data_id, consumable.id).click_link "Edit"
      fill_in "User swipe card id/barcode", with: scientist.swipe_card_id
      fill_in "Name", with: new_consumable.name
      click_button "Update Consumable"
    }.to change{ consumable.reload.name }.to(new_consumable.name)
    expect(page).to have_content("Consumable successfully updated")
  end

  it "does not allow an unauthorised user to manage consumables" do
    consumable = build(:consumable)

    visit new_consumable_path
    expect{
      fill_in "Name", with: consumable.name
      fill_in "Expiry date", with: consumable.expiry_date
      fill_in "Lot number", with: consumable.lot_number
      fill_in "Arrival date", with: consumable.arrival_date
      fill_in "Supplier", with: consumable.supplier
      select consumable_types.first.name, from: 'Consumable type'
      click_button "Create Consumable"
    }.to_not change(Consumable, :count)

    expect(page).to have_content("errors prohibited this record from being saved")

  end


  describe "selecting parents", js: true do

    let!(:consumables) { create_list(:consumable, 3) }

    it "Allows a user to select multiple parents" do
      consumable = build(:consumable)

      visit new_consumable_path

      expect {
        find(:data_behavior, "parents").all("select").last.find("option", text: consumables.first.name).select_option
        find(:data_behavior, "parents").all("li").last.find(:data_behavior, "add_parent").click

        find(:data_behavior, "parents").all("select").last.find("option", text: consumables[1].name).select_option
        find(:data_behavior, "parents").all("li").last.find(:data_behavior, "add_parent").click

        find(:data_behavior, "parents").all("select").last.find("option", text: consumables.last.name).select_option

        fill_in "User swipe card id/barcode", with: scientist.swipe_card_id
        fill_in "Name", with: consumable.name
        fill_in "Expiry date", with: consumable.expiry_date
        fill_in "Lot number", with: consumable.lot_number
        fill_in "Arrival date", with: consumable.arrival_date
        fill_in "Supplier", with: consumable.supplier
        select consumable_types.first.name, from: 'Consumable type'
        click_button "Create Consumable"
      }.to change(Consumable, :count).by(1)

      expect(Consumable.find_by(name: consumable.name).parents.count).to eq(3)

    end

    it "Allows a user to remove parents" do
      consumable = build(:consumable)

      visit new_consumable_path

      expect {
        find(:data_behavior, "parents").all("select").last.find("option", text: consumables.first.name).select_option
        find(:data_behavior, "parents").all("li").last.find(:data_behavior, "add_parent").click

        find(:data_behavior, "parents").all("select").last.find("option", text: consumables[1].name).select_option
        find(:data_behavior, "parents").all("li").last.find(:data_behavior, "add_parent").click

        find(:data_behavior, "parents").all("select").last.find("option", text: consumables.last.name).select_option

        find(:data_behavior, "parents").all("li").last.find(:data_behavior, "remove_parent").click
        find(:data_behavior, "parents").all("li").last.find(:data_behavior, "remove_parent").click

        fill_in "User swipe card id/barcode", with: scientist.swipe_card_id
        fill_in "Name", with: consumable.name
        fill_in "Expiry date", with: consumable.expiry_date
        fill_in "Lot number", with: consumable.lot_number
        fill_in "Arrival date", with: consumable.arrival_date
        fill_in "Supplier", with: consumable.supplier
        select consumable_types.first.name, from: 'Consumable type'
        click_button "Create Consumable"
      }.to change(Consumable, :count).by(1)

      expect(Consumable.find_by(name: consumable.name).parents.count).to eq(1)

    end

  end

end