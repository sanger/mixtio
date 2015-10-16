module Permissions
  class ScientistPermissions < BasePermissions

    def initialize(user)
      super()
      allow :consumables, [:create, :update]
    end

  end
end