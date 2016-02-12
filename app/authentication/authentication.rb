##
# LDAP authentication
#
module Authentication

  ##
  # include this in to ApplicationController
  # will add the standard methods to allow authentication in filters.
  # It will add a current_user method.
  module ControllerConcern

    extend ActiveSupport::Concern

    included do
      helper_method :current_user
    end

    ##
    # When a user tries to sign in to a protected page and it is a get request
    # The request path will be stored in the session so the user can be returned
    # to the requested path once they have signed in.
    def store_location
      session[:return_to] = request.path if request.get?
    end

    ##
    # Return the user to the saved location if it exists
    # otherwise return them to the default location.
    def get_location(default)
      session.delete(:return_to) || default
    end

    ##
    # Check whether the user is signed in.
    # If not store the requested location and redirect them to the sign in path
    def authenticate!
      unless signed_in?
        store_location
        redirect_to(new_session_path)
      end
    end

    ##
    # Authenticate username and password against LDAP
    # If successful add the username to the session.
    def authenticate?(username, password)
      if Authentication::Ldap.authenticate(username, password)
        session[:username] = username
        true
      else
        false
      end
    end

    ##
    # Return the current user or create one using the session username
    def current_user
      @current_user ||= Authentication::CurrentUser.new(User.find_or_create_by(username: session[:username], team: Team.first))
    end

    ##
    # Check whether the user is already signed in
    def signed_in?
      current_user.signed_in?
    end

    ##
    # Here endeth the session. Remove the username from the session object and
    # the current user object.
    def sign_out!
      session[:username] = nil
      current_user.sign_out!
    end

  end

  ##
  # A simple class to contain details of the current user
  class CurrentUser
    attr_reader :user

    ##
    # Create a new current user with a user or not.
    def initialize(user)
      @user = user
    end

    ##
    # A user is signed in if the user exists
    def signed_in?
      user.present? && user.valid?
    end

    ##
    # To sign out set the user to nil
    def sign_out!
      @user = nil
    end

    def method_missing(method, *args)
      user.send(method, *args)
    end

  end

  ##
  # The LDAP class is an interface between the app and the LDAP server
  # Allows users to be authenticated
  class Ldap

    ##
    # The settings is an OpenStruct containing the host, port etc.
    # This will be pulled from the Rails configuration.
    cattr_accessor :settings
    self.settings ||= Rails.configuration.ldap

    attr_reader :username

    ##
    # Create your own settings. Should be a hash of options
    def self.setup(settings)
      self.settings = OpenStruct.new(settings)
    end

    ##
    # Authentication the username and password against LDAP
    def self.authenticate(username, password)
      new(username).authenticate(password)
    end

    ##
    # create a username. This will be LDAP friendly.
    # will be created from the settings (dn, prefix, username and various dc attributes).
    # For example: "dn=user1,ou=pepper,dc=company,dc=org,dc=uk"
    def initialize(username)
      @username = set_username(username)
    end

    ##
    # Authenticat the user by creating a new LDAP object, passing the created user name and password and trying to bind
    def authenticate(password)
      Net::LDAP.new(options(password)).bind
    end

    ##
    # Create a hash of the settings; the host, port, encryption method and auth settings.
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

  ##
  # It will always return true for authenticate which ensures that users can still login in where an LDAP
  # server does not exist in development mode.
  #
  class FakeLdap
    def self.authenticate(username, password)
      true
    end
  end
end