class User < ActiveRecord::Base

  include HasActive

  belongs_to :team

  validates :username, presence: true, uniqueness: true

  validates :team, existence: true

end
