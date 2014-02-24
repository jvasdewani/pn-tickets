class CreateSupplierAssignments < ActiveRecord::Migration
  def change
    create_table :supplier_assignments do |t|
      t.belongs_to :supplier_quote, index: true
      t.belongs_to :supplier, index: true

      t.timestamps
    end
  end
end
