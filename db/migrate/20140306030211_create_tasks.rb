class CreateTasks < ActiveRecord::Migration
  def change
    create_table :tasks do |t|
      t.references :task_type, index: true
      t.string :description
      t.datetime :start_time
      t.datetime :end_time
      t.references :user, index: true

      t.timestamps
    end
  end
end
