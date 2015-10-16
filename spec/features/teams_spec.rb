# As an admin I want to be able to create new teams in the system and edit them in order to allow teams to be tracked in the system.
require "rails_helper"

RSpec.describe "Teams", type: :feature do

  let! (:administrator)        { create(:administrator) }

  it "Allows a user to create a new team" do
    team = build(:team)
    visit teams_path
    click_link "Add new team"
    expect {
      fill_in "User swipe card id/barcode", with: administrator.swipe_card_id
      fill_in "Name", with: team.name
      fill_in "Number", with: team.number
      click_button "Create Team"
    }.to change(Team, :count).by(1)
    expect(page).to have_content("Team successfully created")
  end

  it "Allows a user to edit an existing team" do
    team = create(:team)
    new_team = build(:team)
    visit edit_team_path(team)
    expect {
      fill_in "User swipe card id/barcode", with: administrator.swipe_card_id
      fill_in "Number", with: new_team.number
      click_button "Update Team"
    }.to change { team.reload.number }
  end

  it "Reports an error if the user adds a team with invalid attributes" do
    team = build(:team)
    visit teams_path
    click_link "Add new team"
    expect {
      fill_in "Name", with: team.name
      click_button "Create Team"
    }.to_not change(Team, :count)
    expect(page).to have_content("errors prohibited this record from being saved")
  end

  it "Reports an error if the user is not authorised" do
    team = build(:team)
    visit teams_path
    click_link "Add new team"
    expect {
      fill_in "User swipe card id/barcode", with: administrator.swipe_card_id
      fill_in "Name", with: team.name
      click_button "Create Team"
    }.to_not change(Team, :count)
    expect(page).to have_content("errors prohibited this record from being saved")
  end

end
