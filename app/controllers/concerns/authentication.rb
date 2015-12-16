module Authentication
  extend ActiveSupport::Concern

  def authenticate?(username, password)
    if User.exists?(username: username) && Ldap.authenticate(username, password)
      session[:username] = username
      true
    else
      false
    end
  end

  def current_user
    @current_user ||= CurrentUser.new(session[:username])
  end

  def signed_in?
    current_user.signed_in?
  end

  def sign_out!
    session[:username] = nil
    current_user.sign_out!
  end

  class CurrentUser
    attr_reader :user

    def initialize(username)
      @user = User.new(username: username)
    end

    def signed_in?
      user.username.present?
    end

    def sign_out!
      user.username = nil
    end

  end
end