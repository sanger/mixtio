require 'rails_helper'

RSpec.describe Unit, type: :model do

  it 'should be valid with display name and simple name' do
    expect(build(:unit, display_name: 'μl', simple_name: 'ul')).to be_valid
  end

  it 'should not be valid without simple name' do
    expect(build(:unit, display_name: 'μl', simple_name: nil)).to_not be_valid
  end

  it 'should not be valid without display name' do
    expect(build(:unit, display_name: nil, simple_name: 'ul')).to_not be_valid
  end

  it 'should not be valid without simple name and display name' do
    expect(build(:unit, display_name: nil, simple_name: nil)).to_not be_valid
  end
end
