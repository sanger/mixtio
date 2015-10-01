class User < ActiveRecord::Base

  include HasActive
  include Permissions

  belongs_to :team

  validates :login, presence: true, uniqueness: true

  validates :team, existence: true

  validates_uniqueness_of :swipe_card_id, :barcode, allow_blank: true, allow_nil: true

  validates_with EitherOrValidator, fields: [:swipe_card_id, :barcode]
end
