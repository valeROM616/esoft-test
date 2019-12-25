class CreateTasks < ActiveRecord::Migration[5.2]
  def change
    create_table :tasks do |t|
      t.string :title
      t.text :description
      t.string :date_fin
      t.integer :priority
      t.integer :status
      t.integer :creator
      t.integer :responsible

      t.timestamps
    end
  end
end
