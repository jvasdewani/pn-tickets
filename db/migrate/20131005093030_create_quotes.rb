class CreateQuotes < ActiveRecord::Migration
  def change
    create_table :quotes do |t|
      t.text :requirements
      t.belongs_to :client, index: true
      t.boolean :approved
      t.boolean :goods_received
      t.boolean :payment_received
      t.boolean :payment_sent

      t.timestamps
    end
  end
end
