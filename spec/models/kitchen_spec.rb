require 'rails_helper'

RSpec.describe Kitchen, type: :model do
  it "should not be valid without a name" do
    expect(build(:kitchen, name: nil)).to_not be_valid
  end

  it "should not allow duplicate names" do
    kitchen = create(:kitchen)
    expect(build(:kitchen, name: kitchen.name)).to_not be_valid
  end

  it "should not allow duplicate names with differing case" do
    kitchen = create(:kitchen)
    expect(build(:kitchen, name: kitchen.name.upcase)).to_not be_valid
    expect(build(:kitchen, name: kitchen.name.downcase)).to_not be_valid
  end
end
