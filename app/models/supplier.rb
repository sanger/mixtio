class Supplier < ActiveRecord::Base
  has_many :lots

  validates_presence_of :name
  validates :name, uniqueness: true
end
