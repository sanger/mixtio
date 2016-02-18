require 'rails_helper'

RSpec.describe Printer, type: :model do

  it "is not valid without a name" do
    expect(build(:printer, name: '')).to_not be_valid
  end

end
