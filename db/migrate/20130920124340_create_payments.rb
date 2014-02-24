class CreatePayments < ActiveRecord::Migration
  def change
    create_table :payments do |t|
      t.belongs_to :contract, index: true
      t.date :due_at
      t.date :paid_at

      t.timestamps
    end
  end
end
