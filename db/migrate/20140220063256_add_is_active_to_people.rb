class AddIsActiveToPeople < ActiveRecord::Migration
  def change
    add_column :people, :is_active, :boolean
  end
end
