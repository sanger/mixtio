class Unit < ActiveRecord::Base
  validates :simple_name, :presence => true, :allow_nil => false
  validates :display_name, :presence => true, :allow_nil => false
end
