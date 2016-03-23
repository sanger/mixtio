class Printer < ActiveRecord::Base
  validates :name, :label_type, :presence => true

  belongs_to :label_type
end
