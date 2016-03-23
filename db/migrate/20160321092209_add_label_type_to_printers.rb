class AddLabelTypeToPrinters < ActiveRecord::Migration
  def change
    add_reference :printers, :label_type, index: true, foreign_key: true
  end
end
