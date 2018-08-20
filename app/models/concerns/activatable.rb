module Activatable

  extend ActiveSupport::Concern

  def inactive?
    !active
  end

  def deactivate!
    update_attributes!(active: false)
  end

  def activate!
    update_attributes!(active: true)
  end

  included do
    scope :active, -> { where(active: true) }
    scope :inactive, -> { where(active: false) }
  end
end
