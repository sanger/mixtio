class Batch < Ingredient

  include Auditable
  include HasVolume
  include Mixable

  CONCENTRATION_UNITS = %w[mg/mL mg/µL mM µM].freeze

  has_many :sub_batches, foreign_key: "ingredient_id", dependent: :destroy, inverse_of: :batch
  has_many :consumables, through: :sub_batches
  has_many :consumable_types, through: :consumables
  has_many :ingredients, through: :mixtures

  belongs_to :user, optional: false

  validates :expiry_date, :sub_batches, presence: true
  validates :expiry_date, expiry_date: true, on: :create

  validates :concentration, numericality: { greater_than: 0, allow_nil: true }
  validates :concentration_unit, inclusion: CONCENTRATION_UNITS, allow_nil: true
  validates :concentration_unit, presence: true, if: Proc.new { |o| o.concentration? }

  after_create :generate_batch_number

  # Returns the volume of all consumables that belong to the batch
  # Converts volume to decimals to get exact precision
  def volume
    sub_batches.map{ |sb| sb.volume.to_d * sb.size * (10 ** SubBatch.units[sb.unit]) }.reduce(0, :+)
  end

  def unit
    'L'
  end

  # Returns integer of number of consumables belonging to the batch
  def size
    consumables.count
  end

  def display_concentration
    if concentration?
      "#{concentration} #{concentration_unit}"
    else
      nil
    end
  end

private

  def generate_batch_number
    update_column(:number, "#{self.kitchen.name.upcase.gsub(/\s/, '')}-#{self.id}")
  end
end
