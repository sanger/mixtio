require 'rails_helper'

RSpec.describe Permissions::GuestPermissions, type: :model do

  it "should not allow a guest to do any action" do
    permissions = Permissions.permission_for(build(:guest))
    expect(permissions.allow?('crazy', 'action')).to be_falsey
  end

  it "should not allow a guest to do a real action" do
    permissions = Permissions.permission_for(build(:guest))
    expect(permissions.allow?('user', 'create')).to be_falsey
  end

end