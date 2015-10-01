module Permissions
  class GuestPermissions < BasePermissions

    def initialize(user)
      super()
      allow_none
    end

  end
end