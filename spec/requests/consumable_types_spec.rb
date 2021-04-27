require 'rails_helper'

RSpec.describe "ConsumableType", type: :request do

  before :each do
    sign_in_request
  end

  let(:consumable_type) { create(:consumable_type, team: test_user.team) }

  describe 'PUT deactivate' do
    before do
      put deactivate_consumable_type_path(consumable_type)
    end
    it 'deactivates the consumable_type' do
      expect(consumable_type.reload).to be_inactive
    end
    it 'writes an audit' do
      expect(consumable_type.audits.first.action).to eq('deactivate')
    end
  end

  describe 'PUT activate' do
    let(:consumable_type) { create(:consumable_type, team: test_user.team, active: false) }
    before do
      put activate_consumable_type_path(consumable_type)
    end
    it 'activates the consumable_type' do
      expect(consumable_type.reload).to be_active
    end
    it 'writes an audit' do
      expect(consumable_type.audits.first.action).to eq('activate')
    end
  end

  describe 'GET index' do
    let!(:active_consumable_type) { create(:consumable_type, team: test_user.team, active: true) }
    let!(:inactive_consumable_type) { create(:consumable_type, team: test_user.team, active: false) }

    it 'loads the active consumable_types' do
      get consumable_types_path
      expect(controller.consumable_types).to eq([active_consumable_type])
    end
  end

  describe 'GET archive_index' do
    let!(:active_consumable_type) { create(:consumable_type, team: test_user.team, active: true) }
    let!(:inactive_consumable_type) { create(:consumable_type, team: test_user.team, active: false) }

    it 'loads the inactive consumable_types' do
      get consumable_types_archive_path
      expect(controller.consumable_types).to eq([inactive_consumable_type])
    end
  end
end
