class CreateAssignments < ActiveRecord::Migration
  def change
    create_table :assignments do |t|
      t.belongs_to :person, index: true
      t.belongs_to :department, index: true

      t.timestamps
    end
  end
end
