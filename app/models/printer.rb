class Printer < ActiveRecord::Base
  validates :name, :label_type, :presence => true

  belongs_to :label_type

  enum service: { pmb: 0, sprint: 1 }
end
