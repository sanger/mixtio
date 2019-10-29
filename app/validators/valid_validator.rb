# Calls #valid? on the given value
# If validation fails adds the errors to the parent record
class ValidValidator < ActiveModel::EachValidator

  def validate_each(record, attribute, value)
    if value.respond_to?(:valid?) && value.valid? == false
      value.errors.full_messages.each { |message| record.errors.add(:base, message) }
    end
  end

end
