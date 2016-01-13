module Permissions
  class BasePermissions

    def initialize
      @permissions = {}
    end

    def allow?(controller, action)
      return @all_actions if @all_actions
      @permissions.has_key?(controller.to_s) && @permissions[controller.to_s].include?(action.to_s)
    end

    def allow(controller, actions)
      @permissions[controller.to_s] = Array(actions).collect(&:to_s)
    end

    def allow_all
      @all_actions = true
    end

    def allow_none
      @all_actions = false
    end

    private

    attr_reader :permissions, :all_actions

  end
end