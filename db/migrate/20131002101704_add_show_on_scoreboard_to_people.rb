class AddShowOnScoreboardToPeople < ActiveRecord::Migration
  def change
    add_column :people, :show_on_scoreboard, :boolean
  end
end
