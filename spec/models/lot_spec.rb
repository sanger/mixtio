require 'rails_helper'

RSpec.describe Lot, type: :model do
  it "should not be valid without a name" do
    expect(build(:lot, name: nil)).to_not be_valid
  end

  it "should not be valid without a name" do
    expect(build(:lot, supplier: nil)).to_not be_valid
  end
end
