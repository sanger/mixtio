class LabelType < ActiveRecord::Base
  validates :name, :external_id, presence: true, uniqueness: { case_sensitive: false }

  has_many :printers
end
