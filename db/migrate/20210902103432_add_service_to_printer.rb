class AddServiceToPrinter < ActiveRecord::Migration[6.1]
  def change
    # ActiveRecord doesn't seem to support database enums
    add_column :printers, :service, :integer, null: false, default: 0
  end
end
