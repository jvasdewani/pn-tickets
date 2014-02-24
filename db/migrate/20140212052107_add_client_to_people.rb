class AddClientToPeople < ActiveRecord::Migration
  def change
    add_column :people, :client, :boolean
  end
end
