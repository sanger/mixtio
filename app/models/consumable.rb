class Consumable < ActiveRecord::Base

  include HasOrderByName

  belongs_to :batch

  has_and_belongs_to_many :lots

  validates :batch, :presence => true

  alias_attribute :ingredients, :lots

  after_create :generate_barcode

  private

  def generate_barcode
    update_column(:barcode, "mx-#{self.id}")
  end

end