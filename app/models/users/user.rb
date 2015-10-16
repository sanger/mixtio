class User < ActiveRecord::Base

  include HasActive
  include Permissions
  include SubclassChecker

  belongs_to :team

  validates :login, presence: true, uniqueness: true

  validates :team, existence: true

  validates_uniqueness_of :swipe_card_id, :barcode, allow_blank: true, allow_nil: true

  validates_with EitherOrValidator, fields: [:swipe_card_id, :barcode], on: :create

  before_update :check_password_fields

  has_subclasses :guest, :administrator, :scientist
  
  def self.types
    %w(Scientist Administrator)
  end

  def self.find_by_code(code)
    return Guest.new if code.blank?
    where("swipe_card_id = :code OR barcode = :code", { code: code}).take || Guest.new
  end

private

  def check_password_fields
    remove_password_fields [:swipe_card_id, :barcode].reject { |attr| self[attr].present? }
  end

  def remove_password_fields(attrs)
    restore_attributes(attrs) unless attrs.empty?
  end

end
