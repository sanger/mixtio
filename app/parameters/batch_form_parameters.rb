# Class to encapsulate the parameters passed in to a BatchForm from a request in the BatchesController
# Validates any part of the request that doesn't belong on the Batch or SubBatch models e.g. MixtureParameters
#
class BatchFormParameters
  include ActiveModel::Model

  attr_accessor :consumable_type_id, :expiry_date, :user, :mixture_criteria,
                :mixture_params, :sub_batches, :batch, :action

  attr_reader :kitchen

  validates_with EnumerableValidator, attributes: [:mixture_params], validator: ValidValidator

  def kitchen
    @kitchen ||= user.team
  end

end