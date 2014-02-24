class CreateTasks < ActiveRecord::Migration
  def change
    create_table :tasks do |t|
      t.string :task_name
      t.belongs_to :task_list, index: true

      t.timestamps
    end
  end
end
