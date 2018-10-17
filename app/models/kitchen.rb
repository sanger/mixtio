class Kitchen < ActiveRecord::Base

  include HasOrderByName
  include Activatable
  include Auditable

  has_many :ingredients

  validates_presence_of :name
  validates :product_code, uniqueness: { case_sensitive: false }, if: -> { product_code.present? }

  validates :name, uniqueness: { case_sensitive: false, scope: :product_code }
end
