require 'rails_helper'

RSpec.describe Auditable, type: :model do

  with_model :dummy_model do

    table do |t|
      t.string :name
      t.timestamps null: false
    end

    model { include Auditable }

  end

  it 'should be able to create an audit record' do
    model = DummyModel.create(name: "Dummy")
    model.create_audit(user: 'admin', action: 'create')

    audit = model.audits.first

    expect(audit.user).to eq('admin')
    expect(audit.action).to eq('create')
    expect(audit.auditable_type).to eq('DummyModel')
    expect(audit.record_data.except("created_at", "updated_at")).to eq(model.as_json.except("created_at", "updated_at"))
    expect(model.reload.audits.count).to eq(1)
  end

end