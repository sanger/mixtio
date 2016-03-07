class Consumable < ActiveRecord::Base

  include HasOrderByName

  belongs_to :batch

  enum unit: {
      "ml": -3,
      "μl": -6,
  }

  validates :batch, :presence => true

  after_create :generate_barcode

  def display_volume
    if volume
      i, f = volume.to_i, volume.to_f
      "#{i == f ? i : f}#{unit}"
    else
      nil
    end
  end

  def simple_volume
    display_volume ? display_volume.gsub('μ', 'u') : nil
  end

  private

  def generate_barcode
    update_column(:barcode, Barcode.create(self))
  end

end