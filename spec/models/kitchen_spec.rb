require 'rails_helper'
require Rails.root.join 'spec/models/concerns/activatable.rb'

RSpec.describe Kitchen, type: :model do
  it "should not be valid without a name" do
    expect(build(:kitchen, name: nil)).not_to be_valid
    expect(build(:kitchen, name: '')).not_to be_valid
  end

  it "should not allow duplicate names without product codes" do
    kitchen = create(:kitchen, name: 'xyz')
    expect(build(:kitchen, name: 'XYZ')).not_to be_valid
  end

  it "should allow duplicate names with different product codes" do
    kitchen1 = create(:kitchen, name: 'alpha', product_code: 'xyz')
    kitchen2 = create(:kitchen, name: 'alpha', product_code: 'abc')
    expect(build(:kitchen, name: 'alpha', product_code: 'rst')).to be_valid
  end

  it 'should allow multiple kitchens without a product code' do
    kitchen1 = create(:kitchen, product_code: nil)
    kitchen2 = create(:kitchen, product_code: nil)
    expect(build(:kitchen, product_code: nil)).to be_valid
  end

  it 'should not allow multiple kitchens with the same product code' do
    kitchen = create(:kitchen, product_code: 'Xyz')
    expect(build(:kitchen, product_code: 'xyz')).not_to be_valid
    expect(build(:kitchen, product_code: 'XYZ')).not_to be_valid
  end

  it_behaves_like "activatable"
end
