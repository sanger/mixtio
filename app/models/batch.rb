class Batch < Ingredient

  include Auditable

  has_many :consumables
  has_many :mixtures
  has_many :ingredients, :through => :mixtures

  validates :expiry_date, presence: true, expiry_date: true

  after_create :generate_batch_number

  scope :order_by_created_at, -> { order('created_at desc') }

private

  def generate_batch_number
    update_column(:number, "#{self.kitchen.name.upcase.gsub(/\s/, '')}-#{self.id}")
  end
end
