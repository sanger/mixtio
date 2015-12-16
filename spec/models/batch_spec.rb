require 'rails_helper'

RSpec.describe Batch, type: :model do

  it "should not be valid without an expiry date" do
    expect(build(:batch, expiry_date: nil)).to_not be_valid
  end

  it "should not be valid with an expiry date in the past" do
    batch = build(:batch, expiry_date: 1.day.ago)
    expect(batch).to_not be_valid
    expect(batch.errors.messages[:expiry_date]).to include(I18n.t('errors.future_date'))
  end

  it "should not be valid without a lot" do
    expect(build(:batch, lot: nil)).to_not be_valid
  end

  it "should be able to order by created at" do
    batch1 = create(:batch, created_at: 1.day.from_now)
    batch2 = create(:batch, created_at: 3.day.from_now)
    batch3 = create(:batch, created_at: 2.day.from_now)

    expect(Batch.order_by_created_at).to eq([batch2, batch3, batch1])
  end
end
