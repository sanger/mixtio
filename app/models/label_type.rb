class LabelType < ActiveRecord::Base
  validates :name, :external_id, presence: true, uniqueness: true

  has_many :printers
end
