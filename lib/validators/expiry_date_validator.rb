class ExpiryDateValidator < ActiveModel::EachValidator

  def validate_each(record, attribute, value)
    if value.present? && value < Date.today
      record.errors.add attribute, I18n.t('future_date')
    end
  end
end