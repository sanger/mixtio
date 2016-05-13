class ConsumableLabelSerializer < ActiveModel::Serializer

  attributes :label_1

  def label_1
    {
      barcode_text: object.barcode,
      reagent_name: object.batch.consumable_type.name,
      batch_no: object.batch.number,
      date: "Use by: #{object.batch.expiry_date}",
      barcode: object.barcode,
      volume: object.display_volume,
      storage_condition: object.batch.consumable_type.simple_storage_condition,
    }
  end

end
