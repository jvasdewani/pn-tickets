class CreatePeople < ActiveRecord::Migration
  def change
    create_table :people do |t|
      t.string :username
      t.string :password_digest
      t.string :password_salt
      t.string :forename
      t.string :surname
      t.string :email
      t.boolean :admin
      t.boolean :manager
      t.boolean :tickets
      t.boolean :reports
      t.boolean :contracts
      t.belongs_to :department, index: true

      t.timestamps
    end
  end
end
