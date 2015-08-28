class AddColumnToPlayers < ActiveRecord::Migration
  def change
    add_column :players, :facebookid, :integer, :limit => 8
  end
end
