class CreateSupplierQuotes < ActiveRecord::Migration
  def change
    create_table :supplier_quotes do |t|
      t.belongs_to :quote, index: true
      t.text :description
      t.float :amount

      t.timestamps
    end
  end
end
