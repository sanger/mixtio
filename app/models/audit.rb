class Audit < ActiveRecord::Base
  belongs_to :auditable, polymorphic: true
  belongs_to :user

  validates :action, :record_data, :user, presence: true

  serialize :record_data, JSON
end
