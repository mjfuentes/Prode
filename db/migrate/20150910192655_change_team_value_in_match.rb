class ChangeTeamValueInMatch < ActiveRecord::Migration
  def change
  	change_column :matches, :home_team,  :integer
  	change_column :matches, :away_team,  :integer
  end
end
