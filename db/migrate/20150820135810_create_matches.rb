class CreateMatches < ActiveRecord::Migration
  def change
    create_table :matches do |t|
      t.string :home_team
      t.string :away_team
      t.integer :home_score
      t.integer :away_score
      t.boolean :finished
      t.timestamps null: false
    end
  end
end
