class ConsumableType < ActiveRecord::Base

  validates :name, presence: true, uniqueness: {case_sensitive: false}
  validates_numericality_of :days_to_keep, greater_than: 0, if: Proc.new { |ct| ct.days_to_keep.present? }

  def expiry_date_from_today
    Date.today.advance(days: days_to_keep).to_date.to_s(:uk) if days_to_keep.present?
  end
end
