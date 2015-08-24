class Ancestor < ActiveRecord::Base

  belongs_to :consumable
  belongs_to :family, polymorphic: true
end
