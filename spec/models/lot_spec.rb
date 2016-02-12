require 'rails_helper'

RSpec.describe Lot, type: :model do
  it "is not valid without a number" do
    expect(build(:lot, number: nil)).to_not be_valid
  end
end
