require 'rails_helper'

RSpec.describe Permissions::ScientistPermissions, type: :model do

  let(:permissions) { Permissions.permission_for(build(:scientist)) }

  it "should not allow a scientist to do a crazy action" do
    expect(permissions.allow?('crazy', 'action')).to be_falsey
  end

  it "should not allow a scientist to create or modify a consumable type" do
    expect(permissions.allow?(:consumable_type, :create)).to be_falsey
    expect(permissions.allow?(:consumable_type, :modify)).to be_falsey
  end

  it "should not allow a scientist to create or modify a user" do
    expect(permissions.allow?(:user, :create)).to be_falsey
    expect(permissions.allow?(:user, :modify)).to be_falsey
  end

  it "should allow a scientist to create or modify a consumable" do
    expect(permissions.allow?(:consumables, :create)).to be_truthy
    expect(permissions.allow?('consumables', 'create')).to be_truthy
    expect(permissions.allow?(:consumables, :update)).to be_truthy
  end

end