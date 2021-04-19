class ChangeAuditRecordDataToText < ActiveRecord::Migration[6.1]
  # :string columns have a capacity of 255. That's not long enough.
  def up
    change_column :audits, :record_data, :text
  end
  def down
    change_column :audits, :record_data, :string
  end
end
