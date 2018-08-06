class Project < ActiveRecord::Base
  include Activatable

  validates :name, presence: true, uniqueness: { case_sensitive: false }

  has_many :sub_batches

end
