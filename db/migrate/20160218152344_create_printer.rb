class CreatePrinter < ActiveRecord::Migration[4.2]
  def change
    create_table :printers do |t|
      t.string :name
    end
  end
end
