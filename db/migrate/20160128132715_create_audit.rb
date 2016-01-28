class CreateAudit < ActiveRecord::Migration
  def change
    create_table :audits do |t|
      t.references :auditable, polymorphic: true, index: true
      t.string :action
      t.string :record_data
      t.string :user
      t.timestamps null: false
    end
  end
end
