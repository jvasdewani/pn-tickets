class AddPeopleIdToClients < ActiveRecord::Migration
  def change
    add_column :clients, :people_id, :integer
  end
end
