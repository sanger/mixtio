class BatchForm

  extend ActiveModel::Naming
  include ActiveModel::Conversion
  include ActiveModel::Validations

  ATTRIBUTES = [:ingredients, :consumable_type_id, :expiry_date, :aliquots,
                :aliquot_volume, :aliquot_unit, :batch_volume, :current_user]

  attr_accessor *ATTRIBUTES

  def initialize(attributes = {})
    ATTRIBUTES.each do |attribute|
      send("#{attribute}=", attributes[attribute])
    end
  end

  def persisted?
    false
  end

  validates :consumable_type_id, :expiry_date, :aliquots, :current_user, :batch_volume, presence: true
  validates :aliquots, numericality: {only_integer: true}
  validates :aliquot_volume, numericality: {allow_blank: true, greater_than: 0}
  validates :batch_volume, numericality: {greater_than: 0}

  validate do
    unless batch.valid?
      batch.errors.each do |key, values|
        errors[key] = values
      end
    end
  end

  validate do
    selected_ingredients.each do |ingredient|
      errors[:ingredient] << "consumable type can't be empty" if ingredient[:consumable_type_id].empty?
      errors[:ingredient] << "supplier can't be empty" if ingredient[:kitchen_id].empty?

      if Team.exists?(ingredient[:kitchen_id])
        errors[:ingredient] << "with number #{ingredient[:number]} could not be found" if !Batch.exists?(number: ingredient[:number], kitchen_id: ingredient[:kitchen_id])
      end

    end
  end

  def consumable
    @consumable ||= Consumable.new
  end

  def find_ingredients
    selected_ingredients.map do |ingredient|
      Ingredient.exists?(ingredient) ? Ingredient.where(ingredient).first : Lot.create(ingredient)
    end
  end

  def selected_ingredients
    ingredients.reject { |i| i == "" }
  end

  def batch
    @batch ||= Batch.new(consumable_type_id: consumable_type_id, expiry_date: expiry_date,
                         ingredients: find_ingredients, kitchen: current_user.team,
                         volume: batch_volume, unit: 'L')
  end

  def save
    return false unless valid?

    begin
      ActiveRecord::Base.transaction do
        batch.save!

        attributes = aliquot_volume.to_f > 0 ? {volume: aliquot_volume, unit: aliquot_unit.to_i} : {}
        batch.consumables.create!(Array.new(aliquots.to_i, attributes))

        batch.create_audit(user: current_user, action: 'create')
      end
    rescue
      return false
    end
  end

end