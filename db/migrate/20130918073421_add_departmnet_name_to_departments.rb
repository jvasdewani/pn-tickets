class AddDepartmnetNameToDepartments < ActiveRecord::Migration
  def change
    add_column :departments, :department_name, :string
  end
end
