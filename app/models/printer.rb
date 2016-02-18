class Printer < ActiveRecord::Base
  validates :name, :presence => true
end
