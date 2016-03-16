class CreateLabelTypes < ActiveRecord::Migration
  def change
    create_table :label_types do |t|
      t.string :name
      t.integer :external_id

      t.timestamps null: false
    end
  end
end
