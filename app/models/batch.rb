class Batch < Ingredient

  include Auditable
  include HasVolume

  has_many :consumables
  has_many :consumable_types, through: :consumables
  has_many :mixtures
  has_many :ingredients, through: :mixtures

  validates :expiry_date, presence: true, expiry_date: true
  validates :volume, presence: true, numericality: {greater_than: 0}
  validates :unit, presence: true

  after_create :generate_batch_number

  scope :order_by_created_at, -> { order('created_at desc') }

  def single_barcode?
    consumables.all? {|x| x.barcode == consumables.first.barcode}
  end

  private

  def generate_batch_number
    update_column(:number, "#{self.kitchen.name.upcase.gsub(/\s/, '')}-#{self.id}")
  end
end
