class Barcode

  def self.create(model)
    "#{Rails.configuration.barcode_prefix}-#{model.id}"
  end

end