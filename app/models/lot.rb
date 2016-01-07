class Lot < ActiveRecord::Base
  belongs_to :consumable_type
  belongs_to :supplier
  has_many :batches
  has_many :mixtures

  validates_presence_of :name, :supplier
end
