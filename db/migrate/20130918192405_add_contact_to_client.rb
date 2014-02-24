class AddContactToClient < ActiveRecord::Migration
  def change
    add_column :clients, :contact_phone, :string
    add_column :clients, :contact_phone_ext, :string
  end
end
