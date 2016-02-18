class PrintJobSerializer < ActiveModel::Serializer

  attributes :label_template_id, :printer_name, :labels

  def printer_name
    object.printer
  end

  def labels
    { body: ActiveModel::ArraySerializer.new(object.batch.consumables, each_serializer: ConsumableLabelSerializer) }
  end

end
