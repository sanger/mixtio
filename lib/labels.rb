class Labels

  attr_accessor :consumables

  def initialize(batch)
    @consumables = []
    batch.consumables.group(:sub_batch_id).each do |sub_batch|
      if (batch.single_barcode?(sub_batch))
        @consumables.push(batch.consumables.where(sub_batch_id: sub_batch.sub_batch_id).first)
      else
        @consumables += batch.consumables.where(sub_batch_id: sub_batch.sub_batch_id)
      end
    end
  end

  def to_h
    {
      body: body
    }
  end

private

  def body
    consumables.map do |consumable|
      {
        label_1: {
          barcode_text: consumable.barcode,
          reagent_name: consumable.batch.consumable_type.name,
          batch_no: consumable.batch.number,
          date: "Use by:#{consumable.batch.expiry_date}",
          barcode: consumable.barcode,
          volume: consumable.display_volume,
          storage_condition: consumable.batch.consumable_type.storage_condition,
        }
      }
    end
  end

end
