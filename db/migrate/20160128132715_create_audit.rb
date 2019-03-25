class CreateAudit < ActiveRecord::Migration[4.2]
  def change
    create_table :audits do |t|
      t.references :auditable, polymorphic: true, index: true
      t.belongs_to :user, index: true
      t.string :action
      t.string :record_data
      t.timestamps null: false
    end
  end
end
