class CreateClients < ActiveRecord::Migration
  def change
    create_table :clients do |t|
      t.string :company
      t.date :health_check_date
      t.belongs_to :health_check_department, index: true
      t.belongs_to :health_check_person, index: true
      t.string :wiki_page
      t.string :group
      t.boolean :active_client

      t.timestamps
    end
  end
end
