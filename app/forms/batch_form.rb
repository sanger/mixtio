class BatchForm

  extend ActiveModel::Naming
  include ActiveModel::Conversion
  include ActiveModel::Validations

  ATTRIBUTES = [:lots, :consumable_type_id, :lot_name, :supplier_id, :expiry_date, :arrival_date, :aliquots]

  attr_accessor *ATTRIBUTES

  def initialize(attributes = {})
    ATTRIBUTES.each do |attribute|
      send("#{attribute}=", attributes[attribute])
    end
  end

  def persisted?
    false
  end

  validates :consumable_type_id, :lot_name, :expiry_date, :aliquots, :presence => true
  validates :aliquots, numericality: { only_integer: true }

  validate do
    unless batch.valid?
      batch.errors.each do |key, values|
        errors[key] = values
      end
    end
  end

  validate do
    selected_lots.each do |lot|
      errors[:ingredient] << "consumable type can't be empty" if lot[:consumable_type_id].empty?
      errors[:ingredient] << "lot name can't be empty" if lot[:name].empty?
    end
  end

  def consumable
    @consumable ||= Consumable.new
  end

  def lot
    @lot ||= Lot.find_or_create_by(name: lot_name, supplier_id: supplier_id, consumable_type_id: consumable_type_id)
  end

  def ingredients
    selected_lots.map do |lot|
      Lot.find_or_create_by(lot)
    end
  end

  def selected_lots
    lots.reject { |l| l == "" }
  end

  def batch
    @batch ||= Batch.new(lot: lot, expiry_date: expiry_date)
  end

  def save
    return false unless valid?
    begin
      ActiveRecord::Base.transaction do
        batch.save!
        batch.consumables.create!( (1..aliquots.to_i).map { { lots: ingredients } } )
      end
    rescue StandardError => e
      errors[:save] << e.to_s
      return false
    end
  end

end