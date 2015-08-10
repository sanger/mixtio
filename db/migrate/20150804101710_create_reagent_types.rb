class CreateReagentTypes < ActiveRecord::Migration
  def change
    create_table :reagent_types do |t|
      t.string :name

      t.timestamps null: false
    end
  end
end
