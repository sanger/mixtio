module Auditable

  extend ActiveSupport::Concern

  included do
    has_many :audits, as: :auditable
  end

  def create_audit(params)
    user = params.fetch(:user, 'unknown')
    action = params.fetch(:action, nil)
    audits.create(user: user, action: action, record_data: self)
  end

end