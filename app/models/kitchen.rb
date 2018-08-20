class Kitchen < ActiveRecord::Base

  include HasOrderByName
  include Activatable
  include Auditable

  has_many :ingredients

  validates_presence_of :name
  validates :name, uniqueness: { case_sensitive: false }
end
