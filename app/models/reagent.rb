class Reagent < ActiveRecord::Base

  belongs_to :reagent_type

  validates :name, presence: true
  validates :expiry_date, presence: true, expiry_date: true
  validates :lot_number, presence: true
  validates :reagent_type, existence: true

  after_create :generate_barcode

  private

  def generate_barcode
    update_column(:barcode, "mx-#{self.name.gsub(' ','-').downcase}-#{self.id}")
  end

end