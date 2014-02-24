class CreateServiceAssignments < ActiveRecord::Migration
  def change
    create_table :service_assignments do |t|
      t.belongs_to :contract, index: true
      t.belongs_to :service, index: true

      t.timestamps
    end
  end
end
