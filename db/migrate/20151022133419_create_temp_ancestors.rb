class CreateTempAncestors < ActiveRecord::Migration
  def change
    create_table :temp_ancestors do |t|

      t.belongs_to :family, polymorphic: true
      t.string :family_type
      t.integer :consumable_id
      t.timestamps null: false
    end

    # add_index :temp_ancestors, [:family_id, :family_type, :consumable_id]
  end
end
