class Mixture < ActiveRecord::Base
  belongs_to :lot
  belongs_to :batch
end
