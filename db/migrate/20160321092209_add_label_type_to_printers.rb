class AddLabelTypeToPrinters < ActiveRecord::Migration[4.2]
  def change
    add_reference :printers, :label_type, index: true, foreign_key: true
  end
end
