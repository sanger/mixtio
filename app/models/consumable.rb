class Consumable < ActiveRecord::Base

  include HasOrderByName

  belongs_to :batch

  validates :batch, :presence => true

  after_create :generate_barcode

  private

  def generate_barcode
    update_column(:barcode, Barcode.create(self))
  end

end