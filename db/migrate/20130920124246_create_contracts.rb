class CreateContracts < ActiveRecord::Migration
  def change
    create_table :contracts do |t|
      t.belongs_to :client, index: true
      t.string :contract_name
      t.date :start_date
      t.date :end_date
      t.float :value
      t.string :renewal_type
      t.integer :service_time_allocation
      t.integer :service_time_used
      t.boolean :invoiced
      t.boolean :paid

      t.timestamps
    end
  end
end
