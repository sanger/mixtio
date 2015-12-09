class Consumable < ActiveRecord::Base

  include HasAncestry
  include HasOrderByName

  belongs_to :consumable_type

  validates :name, presence: true
  validates :expiry_date, presence: true, expiry_date: true
  validates :lot_number, presence: true
  validates :consumable_type, existence: true
  validates_numericality_of :aliquots, greater_than: 0

  after_initialize :set_batch_number
  after_create :generate_barcode

  def mix
    (1..self.aliquots).collect do |n|
      Consumable.create(self.attributes.except('aliquots')).add_parents(Consumable.where(id: self.parent_ids))
    end
  end

  def save_or_mix
    new_record? ? mix : save
  end

  def self.get_next_batch_number
    count == 0 ? 1 : maximum(:batch_number) + 1
  end

  def self.latest
    order(created_at: :desc).take
  end

  private

  def generate_barcode
    update_column(:barcode, "mx-#{self.name.gsub(' ','-').downcase}-#{self.id}")
  end

  def set_batch_number
    self.batch_number ||= Consumable.get_next_batch_number
  end

end