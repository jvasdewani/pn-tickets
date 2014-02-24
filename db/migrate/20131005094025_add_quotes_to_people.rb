class AddQuotesToPeople < ActiveRecord::Migration
  def change
    add_column :people, :quotes, :boolean
  end
end
