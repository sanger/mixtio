require 'rails_helper'

RSpec.describe Lot, type: :model do
  it 'is valid with a number' do
    expect(build(:lot, number: 123)).to be_valid
  end
  it 'is valid without a number' do
    expect(build(:lot, number: nil)).to be_valid
  end
end
