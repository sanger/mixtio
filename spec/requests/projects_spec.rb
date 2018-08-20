require 'rails_helper'

RSpec.describe "Projects", type: :request do

  before :each do
    sign_in_request
  end

  let(:project) { create(:project) }

  describe 'PUT deactivate' do
    before do
      put deactivate_project_path(project)
    end
    it 'deactivates the project' do
      expect(project.reload).to be_inactive
    end
    it 'writes an audit' do
      expect(project.audits.first.action).to eq('deactivate')
    end
  end

  describe 'PUT activate' do
    let(:project) { create(:project, active: false) }
    before do
      put activate_project_path(project)
    end
    it 'activates the project' do
      expect(project.reload).to be_active
    end
    it 'writes an audit' do
      expect(project.audits.first.action).to eq('activate')
    end
  end

  describe 'GET index' do
    let!(:active_project) { create(:project, active: true) }
    let!(:inactive_project) { create(:project, active: false) }

    it 'loads the active projects' do
      get projects_path
      expect(controller.projects).to eq([active_project])
    end
  end

  describe 'GET archive_index' do
    let!(:active_project) { create(:project, active: true) }
    let!(:inactive_project) { create(:project, active: false) }

    it 'loads the inactive projects' do
      get projects_archive_path
      expect(controller.projects).to eq([inactive_project])
    end
  end
end
