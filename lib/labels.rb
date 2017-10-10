class Labels

  attr_accessor :consumables

  def initialize(batch)
    @consumables = []
    batch.sub_batches.each do |sub_batch|
      if (sub_batch.single_barcode?)
        @consumables.push(sub_batch.consumables.first)
      else
        @consumables += sub_batch.consumables
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
