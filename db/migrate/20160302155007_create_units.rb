class CreateUnits < ActiveRecord::Migration
  def change
    create_table :units do |t|
      t.string :simple_name
      t.string :display_name

      t.timestamps null: false
    end
  end
end
