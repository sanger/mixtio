require 'rails_helper'

RSpec.describe Audit, type: :model do

  it 'should not be valid without an action' do
    expect(build(:audit, action: nil)).to_not be_valid
  end

  it 'should not be valid without record data' do
    expect(build(:audit, record_data: nil)).to_not be_valid
  end

  it 'should not be valid without a user' do
    expect(build(:audit, user: nil)).to_not be_valid
  end

end
