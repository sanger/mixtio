require 'rails_helper'

RSpec.describe Permissions::AdministratorPermissions, type: :model do

  it "should allow an administrator to do any action" do
    permissions = Permissions.permission_for(build(:administrator))
    expect(permissions.allow?('crazy', 'action')).to be_truthy
  end

  it "should allow an administrator to do a real action" do
    permissions = Permissions.permission_for(build(:administrator))
    expect(permissions.allow?('user', 'create')).to be_truthy
  end

end