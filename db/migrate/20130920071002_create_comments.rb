class CreateComments < ActiveRecord::Migration
  def change
    create_table :comments do |t|
      t.belongs_to :issue, index: true
      t.belongs_to :person, index: true
      t.text :content
      t.string :_pp
      t.string :_np
      t.string :_ps
      t.string :_ns

      t.timestamps
    end
  end
end
