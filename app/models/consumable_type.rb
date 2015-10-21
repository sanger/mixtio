class ConsumableType < ActiveRecord::Base

  validates :name, presence: true, uniqueness: {case_sensitive: false}
  validates_numericality_of :days_to_keep, greater_than: 0, if: Proc.new { |ct| ct.days_to_keep.present? }
end
