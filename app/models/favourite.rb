class Favourite < ActiveRecord::Base
  belongs_to :user
  belongs_to :consumable_type

  validates :user_id, uniqueness: {scope: :consumable_type_id}
end
