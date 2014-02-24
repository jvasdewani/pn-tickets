class CreateBranches < ActiveRecord::Migration
  def change
    create_table :branches do |t|
      t.belongs_to :client, index: true
      t.string :branch_name
      t.string :contact_phone
      t.string :contact_phone_ext

      t.timestamps
    end
  end
end
