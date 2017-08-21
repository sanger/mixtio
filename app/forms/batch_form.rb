class BatchForm

  extend ActiveModel::Naming
  include ActiveModel::Conversion
  include ActiveModel::Validations

  ATTRIBUTES = [:ingredients, :consumable_type_id, :expiry_date, :current_user,
                :single_barcode, :sub_batches]

  attr_accessor *ATTRIBUTES

  def initialize(attributes = {})
    ATTRIBUTES.each do |attribute|
      send("#{attribute}=", attributes[attribute])
    end
  end

  def persisted?
    false
  end

  validates :consumable_type_id, :expiry_date, :sub_batches, :current_user, presence: true

  validate do
    selected_ingredients.each do |ingredient|
      errors[:ingredient] << "consumable type can't be empty" if ingredient[:consumable_type_id].empty?
      errors[:ingredient] << "supplier can't be empty" if ingredient[:kitchen_id].empty?

      if Team.exists?(ingredient[:kitchen_id]) and !Batch.exists?(number: ingredient[:number], kitchen_id: ingredient[:kitchen_id])
        errors[:ingredient] << "with number #{ingredient[:number]} could not be found"
      end

    end

    sub_batches.each do |sub_batch|
      errors[:sub_batch] << "quantity can't be empty" if sub_batch[:quantity].empty?
      errors[:sub_batch] << "quantity must be at least 1" if sub_batch[:quantity].to_i < 1 && sub_batch[:quantity].present?

      errors[:sub_batch] << "volume can't be empty" if sub_batch[:volume].empty?
      errors[:sub_batch] << "volume must be positive" if sub_batch[:volume].to_f <= 0 && sub_batch[:volume].present?
    end

    errors[:expiry_date] << "can't be in the past" if expiry_date.to_date < Date.today

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

    begin
      ActiveRecord::Base.transaction do
        batch.save!

        create_consumables(batch, {volume: aliquot_volume, unit: aliquot_unit.to_i})

        if single_barcode == '1'
          generate_single_barcode(batch)
        end

        batch.create_audit(user: current_user, action: 'create')
      end
    rescue
      return false
    end
  end

  def update(batch)
    return false unless valid?

    begin
      ActiveRecord::Base.transaction do
        # Delete all existing consumables for the batch
        batch.consumables.destroy_all
        
        batch.update_attributes!(consumable_type_id: consumable_type_id,
        expiry_date: expiry_date, ingredients: find_ingredients,
        kitchen: current_user.team, user: current_user.user)


        # Create the new consumables to reflect any changes
        sub_batch_id = 1
        sub_batches.each do |sub_batch|
          create_consumables(batch, sub_batch[:quantity].to_i, {volume: sub_batch[:volume].to_f, unit: sub_batch[:unit].to_i, sub_batch_id: sub_batch_id})
          sub_batch_id += 1
        end

        if single_barcode == '1'
          generate_single_barcode(batch)
        end

        batch.create_audit(user: current_user, action: 'update')
      end
    rescue
      return false
    end
  end

  private
    def create_consumables(batch, quantity, attributes)
      batch.consumables.create!(Array.new(quantity, attributes))
    end

    def generate_single_barcode(batch)
      barcode = batch.consumables.first.barcode
      batch.consumables.each do |consumable|
        consumable.barcode = barcode
        consumable.save!
      end
    end

end
