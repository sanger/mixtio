class Mixture < ActiveRecord::Base
  belongs_to :ingredient
  belongs_to :mixable, polymorphic: true
  belongs_to :unit, optional: true
end
