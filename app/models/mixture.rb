class Mixture < ActiveRecord::Base
  belongs_to :ingredient
  belongs_to :batch
end
