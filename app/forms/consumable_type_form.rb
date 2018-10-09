class ConsumableTypeForm
  include ActiveModel::Model
  include MixableForm
  # Used by form_for
  delegate :persisted?, :id, to: :consumable_type

  attr_accessor :name, :days_to_keep, :storage_condition, :current_user, :consumable_type

  validate :validate_children

  # Implemented so ConsumableTypeForm can be passed into form_for
  def self.model_name
    ActiveModel::Name.new(ConsumableType)
  end

  def save
    persist action: :create
  end

  def update
    persist action: :update
  end

  def consumable_type
    @consumable_type ||= ConsumableType.new
  end

private

  def persist(params)
    begin
      ActiveRecord::Base.transaction do
        # Mixtures are always re-created
        consumable_type.mixtures.destroy_all

        consumable_type.assign_attributes(consumable_type_attributes)

        raise ActiveRecord::RecordInvalid unless valid?

        consumable_type.save
        consumable_type.create_audit(user: current_user, action: params.fetch(:action))
      end
      true
    rescue
      false
    end
  end

  def validate_children
    promote_errors(consumable_type.errors) if consumable_type.invalid?
  end

  def promote_errors(child_errors)
    child_errors.each do |attribute, message|
      errors.add(attribute, message)
    end
  end

  def consumable_type_attributes
    { name: name, days_to_keep: days_to_keep, storage_condition: storage_condition, mixtures: mixtures }
  end

end