module Permissions
  class AdministratorPermissions < BasePermissions

    def initialize(user)
      super()
      allow_all
    end

  end
end