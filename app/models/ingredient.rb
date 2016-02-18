class Ingredient < ActiveRecord::Base
  belongs_to :consumable_type
  belongs_to :kitchen

  has_many :mixtures

  validates :consumable_type, :kitchen, :presence => true
end
