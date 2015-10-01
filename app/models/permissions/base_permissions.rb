module Permissions
  class BasePermissions

    def initialize
      @permissions = {}
    end

    def allow?(controller, action)
      return @all_actions if !@all_actions.nil?
      return false if !@permissions.has_key?(controller)
      @permissions[controller].include?(action) ? true : false
    end

    def allow(controller, actions)
      @permissions[controller] ||= []
      @permissions[controller] = @permissions[controller].union(Array(actions))
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