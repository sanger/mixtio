class ConsumableLabelSerializer < ActiveModel::Serializer

  attributes :label_1

  def label_1
    {
      barcode_text: object.barcode,
      reagent_name: object.batch.consumable_type.name,
      batch_no: object.batch.number,
      date: "Use by: #{object.batch.expiry_date.to_date.to_s(:uk)}",
      barcode: object.barcode,
      volume: object.simple_volume,
      freezer_temperature: object.batch.consumable_type.simple_freezer_temperature,
    }
  end

end
