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

  # Takes the last consumable with a given sub_batch_id and returns whether that sub_batch is
  # single barcode or not
  def single_barcode?(sub_batch)
    if consumables.where(sub_batch_id: sub_batch.sub_batch_id).count == 1
      return true
    end
    consumables.find(sub_batch.id).barcode == consumables.find(sub_batch.id - 1).barcode
  end

  def volume
    consumables.map{ |c| c.volume * (10 ** Consumable.units[c.unit]) }.reduce(0, :+)
  end

  def unit
    'L'
  end

  def size
    consumables.count
  end

  private

  def generate_batch_number
    update_column(:number, "#{self.kitchen.name.upcase.gsub(/\s/, '')}-#{self.id}")
  end
end
