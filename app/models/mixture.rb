class Mixture < ActiveRecord::Base
  belongs_to :ingredient
  belongs_to :batch
  belongs_to :unit, optional: true
end
