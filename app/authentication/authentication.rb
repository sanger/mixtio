module Authentication
  module ControllerConcern

    extend ActiveSupport::Concern

    included do
      helper_method :current_user
    end

    def store_location
      session[:return_to] = request.path if request.get?
    end

    def get_location(default)
      session.delete(:return_to) || default
    end
  
    def authenticate!
      unless signed_in?
        store_location
        redirect_to(new_session_path)
      end
    end

    def authenticate?(username, password)
      if User.exists?(username: username) && Authentication::Ldap.authenticate(username, password)
        session[:username] = username
        true
      else
        false
      end
    end

    def current_user
      @current_user ||= Authentication::CurrentUser.new(session[:username])
    end

    def signed_in?
      current_user.signed_in?
    end

    def sign_out!
      session[:username] = nil
      current_user.sign_out!
    end

  end

  class CurrentUser
    attr_reader :user
    delegate :username, to: :user

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

  class Ldap

    cattr_accessor :settings
    self.settings ||= Rails.configuration.ldap

    attr_reader :username

    def self.setup(settings)
      self.settings = OpenStruct.new(settings)
    end

    def self.authenticate(username, password)
      new(username).authenticate(password)
    end

    def initialize(username)
      @username = set_username(username)
    end

    def authenticate(password)
      Net::LDAP.new(options(password)).bind
    end

    def options(password)
      {
        host: self.settings.host,
        port: self.settings.port,
        encryption: :simple_tls,
        auth: { method: :simple, username: username, password: password }
      }
    end

  private

    def set_username(username)
      "#{self.settings.dn_attribute}=#{username},#{self.settings.prefix}" << self.settings.dc.collect { |dc| ",dc=#{dc}"}.reduce(:<<)
    end
    
  end

  class FakeLdap
    def self.authenticate(username, password)
      true
    end
  end
end