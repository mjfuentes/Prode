class CreateMatches < ActiveRecord::Migration
  def change
    create_table :matches do |t|
      t.integer :home_team_id
      t.integer :away_team_id
      t.integer :home_score
      t.integer :away_score
      t.integer :matchday_id
      t.boolean :finished
      t.timestamps null: false
    end
  end
end
