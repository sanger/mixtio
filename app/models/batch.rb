class Batch < Ingredient

  include Auditable
  include HasVolume

  has_many :sub_batches, foreign_key: "ingredient_id"
  has_many :consumables, through: :sub_batches
  has_many :consumable_types, through: :consumables
  has_many :mixtures
  has_many :ingredients, through: :mixtures

  belongs_to :user

  validates :expiry_date, presence: true, expiry_date: true
  validates :user, presence: true

  after_create :generate_batch_number

  scope :order_by_created_at, -> { order('created_at desc') }

  def self.new_with_sub_batch
    b = Batch.new
    b.sub_batches.build
    b
  end

  # Returns the volume of all consumabls that belong to the batch
  # Converts volume to decimals to get exact precision
  def volume
    consumables.map{ |con| con.volume.to_d * (10 ** Consumable.units[con.unit]) }.reduce(0, :+)
  end

  def unit
    'L'
  end

  # Returns integer of number of consumables belonging to the batch
  def size
    consumables.count
  end

  # Returns the information about the _latest lot_ of each ingredient in this batch
  def ingredients_prefill
    mixtures&.map do |mixture|
      ing = mixture.ingredient
      type = ing.consumable_type
      latest_lot = type.latest_lot
      {
        consumable_type_id: type.id,
        number: latest_lot&.number,
        kitchen_id: latest_lot&.kitchen_id,
        quantity: mixture.quantity,
        unit_id: mixture.unit_id,
      }
    end || []
  end

private

  def generate_batch_number
    update_column(:number, "#{self.kitchen.name.upcase.gsub(/\s/, '')}-#{self.id}")
  end
end
