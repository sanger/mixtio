class Consumable < ActiveRecord::Base

  belongs_to :consumable_type

  validates :name, presence: true
  validates :expiry_date, presence: true, expiry_date: true
  validates :lot_number, presence: true
  validates :consumable_type, existence: true

  after_create :generate_barcode

  private

  def generate_barcode
    update_column(:barcode, "mx-#{self.name.gsub(' ','-').downcase}-#{self.id}")
  end

end