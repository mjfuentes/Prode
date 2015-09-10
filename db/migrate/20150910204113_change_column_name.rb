class ChangeColumnName < ActiveRecord::Migration
  def change
  	rename_column :matches, :home_team, :home_team_id
  	rename_column :matches, :away_team, :away_team_id
  end
end
