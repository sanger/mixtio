class BatchForm

  extend ActiveModel::Naming
  include ActiveModel::Conversion
  include ActiveModel::Validations

  ATTRIBUTES = [:lots, :consumable_type_id, :lot_name, :supplier_id, :expiry_date, :arrival_date, :aliquots, :current_user]

  attr_accessor *ATTRIBUTES

  def initialize(attributes = {})
    ATTRIBUTES.each do |attribute|
      send("#{attribute}=", attributes[attribute])
    end
  end

  def persisted?
    false
  end

  validates :consumable_type_id, :lot_name, :expiry_date, :aliquots, :current_user, :presence => true
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
    @batch ||= Batch.new(lot: lot, expiry_date: expiry_date, ingredients: ingredients)
  end

  def save
    return false unless valid?
    ActiveRecord::Base.transaction do
      batch.save!
      batch.consumables.create!(Array.new(aliquots.to_i, {}))
      batch.create_audit(user: current_user, action: 'create')
    end
  end

end