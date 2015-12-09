##
# This concern can be included for any model with a name.
#
# It allows a collection of all model instances to be returned ordered by name (case insensitive)
module HasOrderByName

  extend ActiveSupport::Concern

  included do
    scope :order_by_name, -> { order('LOWER(name)') }
  end

end