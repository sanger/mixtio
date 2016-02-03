class Batch < ActiveRecord::Base

  include Auditable

  belongs_to :lot

  has_many :consumables
  has_many :mixtures
  has_many :ingredients, :through => :mixtures, :class_name => 'Lot', :source => 'lot'

  validates :expiry_date, presence: true, expiry_date: true
  validates :lot, :presence => true

  scope :order_by_created_at, -> { order('created_at desc') }
end
