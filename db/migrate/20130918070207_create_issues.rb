class CreateIssues < ActiveRecord::Migration
  def change
    create_table :issues do |t|
      t.string :subject
      t.integer :issue_time_cache
      t.integer :response_time_cache
      t.string :status
      t.string :priority
      t.string :checkid
      t.boolean :checkcleared
      t.string :checkstarttime
      t.string :checkstartdate
      t.text :checkdescription
      t.belongs_to :product_type, index: true
      t.belongs_to :checklist, index: true
      t.belongs_to :closed_by, index: true
      t.belongs_to :person, index: true
      t.belongs_to :department, index: true
      t.belongs_to :client, index: true
      t.belongs_to :contact, index: true

      t.timestamps
    end
  end
end
