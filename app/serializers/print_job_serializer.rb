class PrintJobSerializer < ActiveModel::Serializer

  # interim fix for json api integration
  self.root = "data"

  attributes :attributes

  def attributes
    {
      attributes: {
        label_template_id: object.label_template_id,
        printer_name: object.printer,
        labels: labels
      }
    }
  end

  def labels

    if object.batch.single_barcode?
      { body: ActiveModel::ArraySerializer.new([object.batch.consumables.first], each_serializer: ConsumableLabelSerializer) }
    else
      { body: ActiveModel::ArraySerializer.new(object.batch.consumables, each_serializer: ConsumableLabelSerializer) }
    end
  end

end
