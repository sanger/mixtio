class BatchForm

  extend ActiveModel::Naming
  include ActiveModel::Conversion
  include ActiveModel::Validations

  ATTRIBUTES = [:ingredients, :consumable_type_id, :expiry_date, :aliquots,
                :aliquot_volume, :aliquot_unit, :current_user, :single_barcode]

  attr_accessor *ATTRIBUTES

  def initialize(attributes = {})
    ATTRIBUTES.each do |attribute|
      send("#{attribute}=", attributes[attribute])
    end
  end

  def persisted?
    false
  end

  validates :consumable_type_id, :expiry_date, :aliquots, :current_user, presence: true
  validates :aliquots, numericality: {only_integer: true}
  validates :aliquot_volume, numericality: {greater_than: 0}

  validate do
    selected_ingredients.each do |ingredient|
      errors[:ingredient] << "consumable type can't be empty" if ingredient[:consumable_type_id].empty?
      errors[:ingredient] << "supplier can't be empty" if ingredient[:kitchen_id].empty?

      if Team.exists?(ingredient[:kitchen_id]) and !Batch.exists?(number: ingredient[:number], kitchen_id: ingredient[:kitchen_id])
        errors[:ingredient] << "with number #{ingredient[:number]} could not be found"
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
                         user: current_user.user)
  end

  def create
    return false unless valid?

    # Creating a batch
    begin
      ActiveRecord::Base.transaction do
        batch.save!

        attributes = {volume: aliquot_volume, unit: aliquot_unit.to_i}
        batch.consumables.create!(Array.new(aliquots.to_i, attributes))

        if single_barcode == '1'
          barcode = batch.consumables.first.barcode
          batch.consumables.each do |consumable|
            consumable.barcode = barcode
            consumable.save!
          end
        end

        batch.create_audit(user: current_user, action: 'create')
      end
    rescue
      return false
    end
  end

  def update(batch)
    @batch = batch
    debugger
    return false unless valid?

    # Updating a batch
    begin
      ActiveRecord::Base.transaction do
        # Delete all existing consumables for the batch
        batch.consumables.destroy_all
        batch.update_attributes(consumable_type_id: consumable_type_id,
        expiry_date: expiry_date, ingredients: find_ingredients,
        kitchen: current_user.team, user: current_user.user)
        batch.save!

        # Create the new consumables to reflect any changes
        attributes = {volume: aliquot_volume, unit: aliquot_unit.to_i}
        batch.consumables.create!(Array.new(aliquots.to_i, attributes))

        if single_barcode == '1'
          barcode = batch.consumables.first.barcode
          batch.consumables.each do |consumable|
            consumable.barcode = barcode
            consumable.save!
          end
        end

        batch.create_audit(user: current_user, action: 'update')
      end
    rescue
      return false
    end
  end

end
