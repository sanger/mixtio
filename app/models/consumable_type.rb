class ConsumableType < ActiveRecord::Base

  include HasAncestry

  after_save :set_parents, if: -> { parent_ids.present? }
  has_many :consumables

  validates :name, presence: true, uniqueness: {case_sensitive: false}
  validates_numericality_of :days_to_keep, greater_than: 0, if: Proc.new { |ct| ct.days_to_keep.present? }

  alias_attribute :ingredients, :parents

  def expiry_date_from_today
    Date.today.advance(days: days_to_keep).to_date.to_s(:uk) if days_to_keep.present?
  end

  def latest_consumables
    parents.collect { |parent| parent.consumables.latest }.compact
  end

private

  def set_parents
    add_parents(ConsumableType.where(id: self.parent_ids))
  end

end