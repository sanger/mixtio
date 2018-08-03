class Project < ActiveRecord::Base
  validates :name, presence: true, uniqueness: { case_sensitive: false }

  has_many :sub_batches

  def inactive?
    !active
  end

  scope :active, -> { where(active: true) }
  scope :inactive, -> { where(active: false) }
end
