class AddNotifyListToDepartments < ActiveRecord::Migration
  def change
    add_column :departments, :notify_list, :text
  end
end
