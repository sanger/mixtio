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