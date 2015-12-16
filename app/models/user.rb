class User < ActiveRecord::Base

  include HasActive

  belongs_to :team

  validates :username, presence: true, uniqueness: true

  validates :team, existence: true

  def self.authenticate(username, password)
    exists?(username: username) && Ldap.authenticate(username, password)
  end

end
