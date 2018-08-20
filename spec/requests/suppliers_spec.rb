require 'rails_helper'

RSpec.describe "Suppliers", type: :request do

  before :each do
    sign_in_request
  end

  let(:supplier) { create(:supplier) }

  describe 'PUT deactivate' do
    before do
      put deactivate_supplier_path(supplier)
    end
    it 'deactivates the supplier' do
      expect(supplier.reload).to be_inactive
    end
    it 'writes an audit' do
      expect(supplier.audits.first.action).to eq('deactivate')
    end
  end

  describe 'PUT activate' do
    let(:supplier) { create(:supplier, active: false) }
    before do
      put activate_supplier_path(supplier)
    end
    it 'activates the supplier' do
      expect(supplier.reload).to be_active
    end
    it 'writes an audit' do
      expect(supplier.audits.first.action).to eq('activate')
    end
  end

  describe 'GET index' do
    let!(:active_supplier) { create(:supplier, active: true) }
    let!(:inactive_supplier) { create(:supplier, active: false) }

    it 'loads the active suppliers' do
      get suppliers_path
      expect(controller.suppliers).to eq([active_supplier])
    end
  end

  describe 'GET archive_index' do
    let!(:active_supplier) { create(:supplier, active: true) }
    let!(:inactive_supplier) { create(:supplier, active: false) }

    it 'loads the inactive suppliers' do
      get suppliers_archive_path
      expect(controller.suppliers).to eq([inactive_supplier])
    end
  end
end
