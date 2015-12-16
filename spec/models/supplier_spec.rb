require 'rails_helper'

RSpec.describe Supplier, type: :model do
  it "should not be valid without a name" do
    expect(build(:supplier, name: nil)).to_not be_valid
  end

  it "should not allow duplicate names" do
    supplier = create(:supplier)
    expect(build(:supplier, name: supplier.name)).to_not be_valid
  end
end
