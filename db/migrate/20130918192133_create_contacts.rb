class CreateContacts < ActiveRecord::Migration
  def change
    create_table :contacts do |t|
      t.belongs_to :branch, index: true
      t.string :forename
      t.string :surname
      t.string :email
      t.string :contact_phone
      t.string :contact_phone_ext
      t.string :contact_mobile

      t.timestamps
    end
  end
end
