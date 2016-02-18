class CreatePrinter < ActiveRecord::Migration
  def change
    create_table :printers do |t|
      t.string :name
    end
  end
end
