class ConsumableTypeForm
  include ActiveModel::Model
  # Used by form_for
  delegate :persisted?, :id, to: :consumable_type

  attr_accessor :name, :days_to_keep, :storage_condition, :mixture_criteria, :current_user, :consumable_type

  validates :consumable_type, valid: true
  validates_with EnumerableValidator, attributes: [:mixture_parameters], validator: ValidValidator

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

  def mixture_criteria
    @mixture_criteria ||= []
  end

private

  def persist(params)
    begin
      ActiveRecord::Base.transaction do
        # Mixtures are always re-created
        consumable_type.mixtures.destroy_all

        consumable_type.assign_attributes(consumable_type_attributes)

        raise ActiveRecord::RecordInvalid unless valid?

        consumable_type.save!
        consumable_type.create_audit(user: current_user, action: params.fetch(:action))
      end
      true
    rescue
      false
    end
  end

  def consumable_type_attributes
    { name: name, days_to_keep: days_to_keep, storage_condition: storage_condition, mixtures: mixtures }
  end

  def mixtures
    @mixtures ||= mixture_parameters.map { |mixture_param| Mixture.from_params(mixture_param) }
  end

  def mixture_parameters
    @mixture_parameters ||= mixture_criteria.map { |mixture_criteria| MixtureParameters.new(mixture_criteria) }
  end

end