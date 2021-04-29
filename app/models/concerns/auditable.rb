module Auditable

  extend ActiveSupport::Concern

  included do
    has_many :audits, as: :auditable
  end

  def create_audit(params)
    user = params.fetch(:user, nil)
    action = params.fetch(:action, nil)
    audits.create!(user_id: user.id, action: action, record_data: self)
  end

end
