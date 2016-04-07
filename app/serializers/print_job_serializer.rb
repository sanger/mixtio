class PrintJobSerializer < ActiveModel::Serializer

  attributes :label_template_id, :printer_name, :labels

  def label_template_id
    object.label_template_id
  end

  def printer_name
    object.printer
  end

  def labels
    if object.batch.single_barcode?
      consumables = [object.batch.consumables.first]
    else
      consumables = object.batch.consumables
    end

    {
        body: consumables.map { |consumable| ConsumableLabelSerializer.new(consumable).attributes }
    }
  end

end
