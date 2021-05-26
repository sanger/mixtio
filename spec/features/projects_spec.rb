require "rails_helper"

RSpec.describe "Projects", type: :feature, js: true do

  let!(:project) { create(:project) }

  before(:each) do
    sign_in
  end

  describe "#edit" do

    let(:edit_a_project) do
      visit edit_project_path(project)
      fill_in "Name", with: "New project name"
      click_button "Update Project"
    end

    it "allows a user to edit an existing project" do
      expect { edit_a_project }.to change { project.reload.name }.to("New project name")
      expect(page).to have_content("Project successfully updated")
    end

  end

end
