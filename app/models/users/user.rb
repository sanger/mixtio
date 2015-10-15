class User < ActiveRecord::Base

  include HasActive
  include Permissions

  belongs_to :team

  validates :login, presence: true, uniqueness: true

  validates :team, existence: true

  validates_uniqueness_of :swipe_card_id, :barcode, allow_blank: true, allow_nil: true

  
  def self.types
    %w(Scientist Administrator)
  end
  validates_with EitherOrValidator, fields: [:swipe_card_id, :barcode], on: :create

  before_update :check_password_fields

private

  def check_password_fields
    remove_password_fields [:swipe_card_id, :barcode].reject { |attr| self[attr].present? }
  end

  def remove_password_fields(attrs)
    restore_attributes(attrs) unless attrs.empty?
  end

end
