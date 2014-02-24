class RemoveNameFromDepartments < ActiveRecord::Migration
  def change
    remove_column :departments, :name, :string
  end
end
