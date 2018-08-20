class CreateSubBatchesAndProjects < ActiveRecord::Migration[4.2]
  def change
    create_table :sub_batches do |t|
      t.float :volume
      t.integer :unit
      t.integer :project_id
      t.references :ingredient, index: true, foreign_key: true
      t.timestamps null: false
    end

    add_index :sub_batches, :project_id
    add_foreign_key :sub_batches, :projects

    if !Project.find_by(name: "Default Project").present?
      default_project = Project.create!(name: "Default Project")
    else
      default_project = Project.find_by(name: "Default Project")
    end

    Batch.all.each do |batch|
      consumable = Consumable.find_by(batch_id: batch.id)
      sub_batch = SubBatch.create!(volume: consumable["volume"],
                                   unit: consumable["unit"],
                                   ingredient_id: batch.id,
                                   project_id: default_project.id)

      Consumable.where(batch_id: batch.id).each do |consumable|
        consumable.update_attribute(:sub_batch_id, sub_batch.id)
      end
    end

  end
end
