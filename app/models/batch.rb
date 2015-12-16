class Batch < ActiveRecord::Base

  belongs_to :lot

  has_many :consumables

  validates :expiry_date, presence: true, expiry_date: true
  validates :lot, :presence => true

  scope :order_by_created_at, -> { order('created_at desc') }
end
