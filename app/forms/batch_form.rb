# Responsible for creating a new Batch, along with its SubBatches and Mixtures
class BatchForm
  include ActiveModel::Model

  attr_accessor :params

  validates :params, valid: true

  def save
    begin
      ActiveRecord::Base.transaction do
        batch.assign_attributes(batch_attributes)

        return false if invalid?

        # Clear the SubBatches before using #build to build new ones
        # Can't do `batch.sub_batches = new_sub_batches` because it immediately throws an unhelpful error
        # if the new_sub_batches aren't valid
        batch.sub_batches.clear
        batch.sub_batches.build(params.sub_batches)

        # Always create new mixtures
        batch.mixtures = build_mixtures

        batch.save!
        batch.create_audit(user: params.user, action: params.action)
      end
      true
    rescue => e
      # Put whatever the errors were on the Batch onto the BatchForm
      promote_errors(batch.errors)
      # Make sure we still give an error message even if batch.errors is empty
      if batch.errors.empty?
        errors.add('Exception', e.message)
      end
      Rails.logger.error(([e.message] + e.backtrace).join("\n    "))
      false
    end
  end

  # Batch will be either the one passed in on params or a new one
  # @return [Batch]
  def batch
    @batch ||= (params.batch.nil?) ? Batch.new : params.batch
  end

private

  def batch_attributes
    {
      consumable_type_id: params.consumable_type_id,
      expiry_date: params.expiry_date,
      user: params.user,
      kitchen: params.kitchen,
      mixture_criteria: params.mixture_criteria,
      concentration: params.concentration,
      concentration_unit: params.concentration.present? ? params.concentration_unit : nil,
    }
  end

  def build_mixtures
    params.mixture_params.map { |mixture_param| Mixture.from_params(mixture_param) }
  end

  def promote_errors(child_errors)
    child_errors.each do |child_error|
      errors.add(child_error.attribute, child_error.message)
    end
  end

end
