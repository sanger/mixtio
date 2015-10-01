module Permissions
  class ScientistPermissions < BasePermissions

    def initialize(user)
      super()
      allow :consumable, [:create, :update]
    end

  end
end