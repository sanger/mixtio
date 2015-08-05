require "rails_helper"

RSpec.describe "ReagentTypes", type: :feature do 
  
  it "Allows a user to create a new reagent type" do
    reagent_type = build(:reagent_type)

    visit reagent_types_path
    click_link "Add new reagent type"
    expect{
      fill_in "Name", with: reagent_type.name 
      click_button "Create Reagent type"
    }.to change(ReagentType, :count).by(1)
    expect(page).to have_content("Reagent type successfully created")
  end

  it "Reports an error if a user adds a reagent type with invalid attributes" do

    reagent_type = create(:reagent_type)

    visit new_reagent_type_path
    expect{
      fill_in "Name", with: reagent_type.name 
      click_button "Create Reagent type"
    }.to_not change(ReagentType, :count)
    expect(page).to have_content("error prohibited this record from being saved")
  end

  it "Allows a user to edit an existing reagent type" do
    reagent_type = create(:reagent_type)
    new_reagent_type = build(:reagent_type)

    visit reagent_types_path
    expect{
      find(:data_id, reagent_type.id).click_link "Edit"
      fill_in "Name", with: new_reagent_type.name
      click_button "Update Reagent type"
    }.to change{ reagent_type.reload.name }.to(new_reagent_type.name)
    expect(page).to have_content("Reagent type successfully updated")
  end

end