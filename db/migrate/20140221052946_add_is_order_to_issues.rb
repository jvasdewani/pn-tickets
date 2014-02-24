class AddIsOrderToIssues < ActiveRecord::Migration
  def change
    add_column :issues, :is_order, :integer
  end
end
