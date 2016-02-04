class User < ActiveRecord::Base
  validates_presence_of :username

  has_many :favourites
  has_many :consumable_types, :through => :favourites

end
