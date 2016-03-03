class Consumable < ActiveRecord::Base

  include HasOrderByName

  belongs_to :batch
  belongs_to :unit

  validates :batch, :presence => true

  after_create :generate_barcode

  def display_volume
    make_volume(unit ? unit.display_name : nil)
  end

  def simple_volume
    make_volume(unit ? unit.simple_name : nil)
  end

  private

  def make_volume(suffix)
    if volume
      i, f = volume.to_i, volume.to_f
      "#{i == f ? i : f}#{suffix}"
    else
      nil
    end
  end

  def generate_barcode
    update_column(:barcode, Barcode.create(self))
  end

end