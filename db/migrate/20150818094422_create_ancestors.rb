class CreateAncestors < ActiveRecord::Migration
  def change
    create_table :ancestors do |t|
      t.string :family_name
      t.integer :family_id
      t.string :relation_type
      t.integer :relation_id

      t.timestamps null: false
    end

    add_index :ancestors, [:family_id, :relation_type, :relation_id]

  end
end

