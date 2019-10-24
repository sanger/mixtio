class Ingredient < ActiveRecord::Base
  belongs_to :consumable_type, optional: false
  belongs_to :kitchen, optional: false
  has_many :mixtures
end
