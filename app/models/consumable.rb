class Consumable < ActiveRecord::Base

  belongs_to :consumable_type

  has_many :ancestors
  has_many :children, through: :ancestors, source: :family, class_name: 'Consumable', source_type: 'Child'
  has_many :parents, through: :ancestors, source: :family, class_name: 'Consumable', source_type: 'Parent'

  validates :name, presence: true
  validates :expiry_date, presence: true, expiry_date: true
  validates :lot_number, presence: true
  validates :consumable_type, existence: true
  validates_numericality_of :number_of_children, greater_than: 0

  after_initialize :set_batch_number
  after_create :generate_barcode

  def add_children(children)
    Array(children).each { |child| add_ancestor(child, self) }
    self
  end

  def add_parents(parents)
    Array(parents).each { |parent| add_ancestor(self, parent) }
    self
  end

  def mix
    (1..self.number_of_children).collect do |n|
      Consumable.create(self.attributes.except('number_of_children')).add_parents(Consumable.where(id: self.parent_ids))
    end
  end

  def save_or_mix
    new_record? ? mix : save
  end

  def parent_ids=(parent_ids)
    super(parent_ids.instance_of?(String) ? parent_ids.split(',') : parent_ids)
  end

  def self.get_next_batch_number
    count == 0 ? 1 : maximum(:batch_number) + 1
  end

  private

  def generate_barcode
    update_column(:barcode, "mx-#{self.name.gsub(' ','-').downcase}-#{self.id}")
  end

  def set_batch_number
    self.batch_number ||= Consumable.get_next_batch_number
  end

  def add_ancestor(child, parent)
    Ancestor.create(family_id: child.id, consumable_id: parent.id, family_type: "Child")
    Ancestor.create(family_id: parent.id, consumable_id: child.id, family_type: "Parent")
  end

end