class CreateAncestors < ActiveRecord::Migration
  def change
    create_table :ancestors do |t|

      t.belongs_to :family, polymorphic: true
      t.string :family_type
      t.integer :consumable_id
      t.timestamps null: false
    end

    add_index :ancestors, [:family_id, :family_type, :consumable_id]
  end
end
