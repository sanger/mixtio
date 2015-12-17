module Authentication
  module ControllerConcern

    extend ActiveSupport::Concern 

    def authenticate!
      redirect_to(new_session_path) unless signed_in?
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

  class Ldap

    cattr_accessor :port
    self.port = 111

    cattr_accessor :host
    self.host = "host"

    cattr_accessor :dn_attribute
    self.dn_attribute = "dn"

    cattr_accessor :prefix
    self.prefix = "ou=abc"

    cattr_accessor :dc 
    self.dc = ["a","b","c"]

    attr_reader :username

    def self.setup(options = {})
      set_options(options) unless options.empty?
      yield self if block_given?
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
        host: self.host,
        port: self.port,
        encryption: :simple_tls,
        auth: { method: :simple, username: username, password: password }
      }
    end

  private

    def set_username(username)
      "#{self.dn_attribute}=#{username},#{self.prefix}" << self.dc.collect { |dc| ",dc=#{dc}"}.reduce(:<<)
    end

    def self.set_options(options)
      options.each do |k,v|
        class_variable_set("@@#{k.to_s}",v)
      end
    end
    
  end

  class FakeLdap
    def self.authenticate(username, password)
      true
    end
  end
end