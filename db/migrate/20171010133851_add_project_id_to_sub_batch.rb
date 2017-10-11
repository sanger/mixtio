class AddProjectIdToSubBatch < ActiveRecord::Migration
  def change
    add_column :sub_batches, :project_id, :integer
  end

  add_index :sub_batches, :project_id
  add_foreign_key :sub_batches, :projects
end
