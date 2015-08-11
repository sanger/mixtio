class Reagent < ActiveRecord::Base

  validates :name, presence: true
  validates :expiry_date, presence: true

  validate :expiry_date_cannot_be_in_the_past

  def expiry_date_cannot_be_in_the_past
    if expiry_date.present? && expiry_date < Date.today
      errors.add(:expiry_date, "can't be in the past")
    end
  end
end