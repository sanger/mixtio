class Batch < Ingredient

  include Auditable
  include HasVolume

  has_many :consumables
  has_many :consumable_types, through: :consumables
  has_many :mixtures
  has_many :ingredients, through: :mixtures

  belongs_to :user

  validates :expiry_date, presence: true, expiry_date: true
  validates :user, presence: true

  after_create :generate_batch_number

  scope :order_by_created_at, -> { order('created_at desc') }

  def single_barcode?
    consumables.count > 1 and consumables.all? {|x| x.barcode == consumables.first.barcode}
  end

  def volume
    consumables.map{ |c| c.volume * (10 ** Consumable.units[c.unit]) }.reduce(0, :+)
  end

  def unit
    'L'
  end

  def get_aliquot_count
    consumables.count
  end

  def get_aliquot_volume
    consumables.first.volume
  end

  def get_aliquot_unit
    consumables.first["unit"]
  end

  private

  def generate_batch_number
    update_column(:number, "#{self.kitchen.name.upcase.gsub(/\s/, '')}-#{self.id}")
  end
end
