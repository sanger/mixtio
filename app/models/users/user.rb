class User < ActiveRecord::Base

  include HasActive
  include Permissions
  include SubclassChecker

  belongs_to :team

  validates :username, presence: true, uniqueness: true

  validates :team, existence: true

  has_subclasses :guest, :administrator, :scientist
  
  def self.types
    %w(Scientist Administrator)
  end

  def self.authenticate(username, password)
    exists?(username: username) && Ldap.authenticate(username, password)
  end

end
