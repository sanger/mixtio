class BatchForm

  extend ActiveModel::Naming
  include ActiveModel::Conversion
  include ActiveModel::Validations

  ATTRIBUTES = [:ingredients, :consumable_type_id, :expiry_date, :current_user,
                :sub_batches]

  attr_accessor *ATTRIBUTES

  def initialize(attributes = {})
    ATTRIBUTES.each do |attribute|
      send("#{attribute}=", attributes[attribute])
    end
  end

  def persisted?
    false
  end

  validates :consumable_type_id, :expiry_date, :current_user, presence: true

  validate do
    selected_ingredients.each do |ingredient|
      errors[:ingredient] << "consumable type can't be empty" if ingredient[:consumable_type_id].empty?
      errors[:ingredient] << "supplier can't be empty" if ingredient[:kitchen_id].empty?

      if Team.exists?(ingredient[:kitchen_id]) and !Batch.exists?(number: ingredient[:number], kitchen_id: ingredient[:kitchen_id])
        errors[:ingredient] << "with number #{ingredient[:number]} could not be found"
      end

    end

    if sub_batches.nil?
      errors[:batch] << "must contain at least 1 sub-batch"
    else
      sub_batches.each do |sub_batch|
        errors["Sub-Batch"] << "aliquots can't be empty" if sub_batch[:quantity].empty?
        errors["Sub-Batch"] << "aliquots must be at least 1" if sub_batch[:quantity].to_i < 1 && sub_batch[:quantity].present?

        errors["Sub-Batch"] << "volume can't be empty" if sub_batch[:volume].empty?
        errors["Sub-Batch"] << "volume must be positive" if sub_batch[:volume].to_f <= 0 && sub_batch[:volume].present?
      end
    end

    errors[:expiry_date] << "can't be in the past" if expiry_date.present? && expiry_date.to_date < Date.today

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

        # Create the consumables for each sub-batch
        sub_batches.each do |sub_batch|
          sub_batch_record = create_sub_batch(batch, sub_batch)

          create_consumables(sub_batch_record, sub_batch[:quantity].to_i, {sub_batch_id: sub_batch_record.id})
          if sub_batch[:barcode_type] == "single"
            generate_single_barcode(sub_batch_record.consumables)
          end
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
        batch.sub_batches.each do |old_sub_batch|
          old_sub_batch.consumables.destroy_all
        end
        batch.sub_batches.destroy_all

        # Update attributes for the batch record
        batch.update_attributes!(consumable_type_id: consumable_type_id,
        expiry_date: expiry_date, ingredients: find_ingredients,
        kitchen: current_user.team, user: current_user.user)


        # Create the consumables for each sub-batch
        sub_batches.each do |sub_batch|
          sub_batch_record = create_sub_batch(batch, sub_batch)
          create_consumables(sub_batch_record, sub_batch[:quantity].to_i, {sub_batch_id: sub_batch_record.id})
          if sub_batch[:barcode_type] == "single"
            generate_single_barcode(sub_batch_record.consumables)
          end
        end

        batch.create_audit(user: current_user, action: 'update')
      end
    rescue
      return false
    end
  end

  private
    def create_sub_batch(batch, sub_batch)
      batch.sub_batches.create!(sub_batch.except(:barcode_type, :quantity))
    end

    def create_consumables(sub_batch, quantity, attributes)
      sub_batch.consumables.create!(Array.new(quantity, attributes))
    end

    def generate_single_barcode(sub_batch_consumables)
      barcode = sub_batch_consumables.first.barcode
      sub_batch_consumables.each do |consumable|
        consumable.barcode = barcode
        consumable.save!
      end
    end

end
