require "rails_helper"

RSpec.describe "Reagents", type: feature do

  it "Displays a list of reagents to the user" do
    reagent = create(:reagent)
    reagent_2 = create(:reagent)

    visit reagents_path

    expect(page).to have_content(reagent.name)
    expect(page).to have_content(reagent_2.name)
  end

  it "Allows a user to create a new reagent" do
    reagent = build(:reagent)

    visit reagents_path
    click_link "Add new reagent"
    expect{
      fill_in "Name", with: reagent.name
      fill_in "Expiry date", with: reagent.expiry_date
      click_button "Create Reagent"
    }.to change(Reagent, :count).by(1)
    expect(page).to have_content("Reagent successfully created")
  end

  it "Reports an error if a user adds a reagent with invalid attributes" do

    reagent = build(:reagent, name: nil)

    visit new_reagent_path
    expect{
      fill_in "Name", with: reagent.name
      fill_in "Expiry date", with: reagent.expiry_date
      click_button "Create Reagent"
    }.to_not change(Reagent, :count)

    expect(page).to have_content("error prohibited this record from being saved")
  end

  it "Allows a user to edit a reagent" do
    reagent = create(:reagent)
    new_reagent = build(:reagent)

    visit reagents_path
    expect{
      find(:data_id, reagent.id).click_link "Edit"
      fill_in "Name", with: new_reagent.name
      click_button "Update Reagent"
    }.to change{ reagent.reload.name }.to(new_reagent.name)
    expect(page).to have_content("Reagent successfully updated")
  end

end