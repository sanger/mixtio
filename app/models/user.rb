class User < ActiveRecord::Base
  has_many :favourites
  has_many :consumable_types, :through => :favourites
  has_many :audits

  belongs_to :team

  validates_presence_of :username, :team
end
